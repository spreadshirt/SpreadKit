//
//  SPClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPClient.h"
#import "SPObjectMappingProvider.h"
#import "SPObjectManager.h"
#import "SPModel.h"
#import "SPConstants.h"


static SPClient *sharedClient = nil;

@implementation SPClient
{
    SPObjectManager *manager;
    NSMutableDictionary *entityURLs;
}

@synthesize apiKey, shopId, userId, secret, platform, baseURL;

+ (SPClient *)sharedClient
{
    return sharedClient;
}

+ (void)setSharedClient:(SPClient *)client
{
    sharedClient = client;
}

+ (SPClient *)clientWithShopId:(NSString *)shopId andApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    SPClient *client = [[SPClient alloc] initWithApiKey:apiKey andSecret:secret andUserId:nil andShopId:shopId andPlatform:nil];
    return client;
}

+ (SPClient *)clientWithShopId:(NSString *)shopId andApiKey:(NSString *)apiKey andSecret:(NSString *)secret andPlatform:(NSString *)platform
{
    SPClient *client = [[SPClient alloc] initWithApiKey:apiKey andSecret:secret andUserId:nil andShopId:shopId andPlatform:platform];
    return client;
}

+ (SPClient *)clientWithUserId:(NSString *)userId andApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    SPClient *client = [[SPClient alloc] initWithApiKey:apiKey andSecret:secret andUserId:userId andShopId:nil andPlatform:nil];
    return client;
}

+ (SPClient *)clientWithUserId:(NSString *)userId andApiKey:(NSString *)apiKey andSecret:(NSString *)secret andPlatform:(NSString *)platform
{
    SPClient *client = [[SPClient alloc] initWithApiKey:apiKey andSecret:secret andUserId:userId andShopId:nil andPlatform:platform];
    return client;
}

- (id)initWithApiKey:(NSString *)theApiKey
           andSecret:(NSString *)theSecret
           andUserId:(NSString *)theUserId
           andShopId:(NSString *)theShopId
         andPlatform:(NSString *)thePlatform;
{
    self = [self init];
    if (self) {
        apiKey = theApiKey;
        secret = theSecret;
        userId = theUserId;
        shopId = theShopId;
        
        platform = thePlatform;
        
        [self setBaseUrlForPlatform];
        
        manager = [SPObjectManager objectManagerWithApiKey:apiKey andSecret:secret];
        entityURLs = [NSMutableDictionary dictionary];
        
        // set the singleton instance
        if (sharedClient == nil) {
            [SPClient setSharedClient:self];
        }
    }
    return self;
}

- (void)setBaseUrlForPlatform {
    if ([self.platform isEqualToString:SPPlatformEU]) {
        baseURL = @"http://api.spreadshirt.net/api/v1";
    } else if ([self.platform isEqualToString:SPPlatformNA]) {
        baseURL = @"http://api.spreadshirt.com/api/v1";
    }
}

- (void)getShopAndOnCompletion:(void (^)(SPShop *, NSError *))completion
{
    NSURL *shopURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shops/%@", baseURL, self.shopId]];
    
    SPShop *stubShop = [[SPShop alloc] init];
    stubShop.url = shopURL;
    
    [self get:stubShop completion:^(id loadedObject, NSError *error) {
        [self setup:loadedObject completion:^{
            completion(loadedObject, error);
        }];
    }];
}

- (void)getUserAndOnCompletion:(void (^)(SPUser *, NSError *))completion
{
    NSURL *userURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", baseURL, self.shopId]];
    
    SPUser *stubUser = [[SPUser alloc] init];
    stubUser.url = userURL;
    
    [self get:stubUser completion:^(id loadedObject, NSError *error) {
        [self setup:loadedObject completion:^{
            completion(loadedObject, error);
        }];
    }];
}


- (void)get:(id)object completion:(void (^)(id, NSError *))completion
{
    [self get:object params:nil completion:completion];
}

- (void)get:(id)object params:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    [manager getObject:object params:params completion:^(id loaded, NSError *error) {
        completion(loaded, error);
    }];
}

- (void)get:(Class)classOfObject identifier:(NSString *)identifier completion:(void (^)(id, NSError *))completion
{
    if ([[entityURLs allKeys] containsObject:NSStringFromClass(classOfObject)]) {
        NSURL *entityBaseUrl = [entityURLs objectForKey:NSStringFromClass(classOfObject)];
        id stub = [[classOfObject alloc] init];
        NSURL *objectURL = [entityBaseUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", identifier]];
        [stub setUrl:objectURL];
        [self get:stub completion:completion];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"SpreadKit could not infer the download URL for the requested object" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:SPErrorDomain code:SPURLInferError userInfo:userInfo];
        completion(nil, error);
    }
}

- (SPList *)listOf:(Class)classOfObjects
{
    if ([[entityURLs allKeys] containsObject:NSStringFromClass(classOfObjects)]) {
        NSURL *listUrl = [entityURLs objectForKey:NSStringFromClass(classOfObjects)];
        SPList *list = [[SPList alloc] init];
        [list setUrl:listUrl];
        return list;
    } else {
        return nil;
    }
}

-(void)post:(id)object completion:(void (^)(id, NSError *))completion
{
    NSURL *url = [entityURLs objectForKey:NSStringFromClass([object class])];
    [manager postObject:object toURL:url completion:completion];
}

- (void)put:(id)object completion:(void (^)(id, NSError *))completion
{
    [manager putObject:object completion:completion];
}

- (void)delete:(id)object completion:(void (^)(NSError *))completion
{
    [manager deleteObject:object completion:completion];
}

// takes a shop or user and extracts and remembers
// all URLs for later posting and getting via id of objects
// sets locale on object manager
-  (void)setup:(id)object completion:(void (^)(void))completion
{
    [entityURLs setValue:[object products].url forKey:NSStringFromClass([SPProduct class])];
    [entityURLs setValue:[object designs].url forKey:NSStringFromClass([SPDesign class])];
    [entityURLs setValue:[object baskets].url forKey:NSStringFromClass([SPBasket class])];
    [entityURLs setValue:[object articles].url forKey:NSStringFromClass([SPArticle class])];
    [entityURLs setValue:[object productTypes].url forKey:NSStringFromClass([SPProductType class])];
    [entityURLs setValue:[object currencies].url forKey:NSStringFromClass([SPCurrency class])];
    [entityURLs setValue:[object languages].url forKey:NSStringFromClass([SPLanguage class])];
    [entityURLs setValue:[object countries].url forKey:NSStringFromClass([SPCountry class])];
    [entityURLs setValue:[object printTypes].url forKey:NSStringFromClass([SPPrintType class])];
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    __block NSString *countryCodeToUse;
    __block NSString *languageCodeToUse;
    
    SPList *languages = [self listOf:[SPLanguage class]];
    languages.limit = @1000;
    SPList *countries = [self listOf:[SPCountry class]];
    countries.limit = @1000;
    
    [self get:languages completion:^(NSArray *objects, NSError *error) {
        for (SPLanguage *language in objects) {
            if ([language.isoCode isEqualToString:languageCode]) {
                languageCodeToUse = languageCode;
            }
        }
        if (languageCodeToUse) {
            [self get:countries completion:^(NSArray *objects, NSError *error) {
                for (SPCountry *country in objects) {
                    if ([country.isoCode isEqualToString:countryCode]) {
                        countryCodeToUse = countryCode;
                    }
                }
                if (countryCodeToUse)
                {
                    manager.locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSString stringWithFormat:@"%@_%@", languageCode, countryCode]];
                }
                completion();
            }];
        } else {
            completion();
        }
    }];
}

@end
