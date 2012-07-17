//
//  SKClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKClient.h"
#import "SKObjectMappingProvider.h"
#import "SKObjectManager.h"

#import "SKModel.h"

#import "Constants.h"


static SKClient *sharedClient = nil;
NSString * const BASE = @"http://api.spreadshirt.net/api/v1";

@implementation SKClient
{
    NSURL *baseUrl;
    SKObjectManager *manager;
    NSMutableDictionary *entityURLs;
}

@synthesize apiKey, shopId, userId, secret;

+ (SKClient *)sharedClient
{
    return sharedClient;
}

+ (void)setSharedClient:(SKClient *)client
{
    sharedClient = client;
}

+ (SKClient *)clientWithShopId:(NSString *)shopId andApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    SKClient *client = [[SKClient alloc] initWithApiKey:apiKey andSecret:secret andUserId:nil andShopId:shopId];
    return client;
}

+ (SKClient *)clientWithUserId:(NSString *)userId andApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    SKClient *client = [[SKClient alloc] initWithApiKey:apiKey andSecret:secret andUserId:userId andShopId:nil];
    return client;
}

- (id)initWithApiKey:(NSString *)theApiKey 
           andSecret:(NSString *)theSecret 
           andUserId:(NSString *)theUserId
           andShopId:(NSString *)theShopId
{
    self = [self init];
    if (self) {
        apiKey = theApiKey;
        secret = theSecret;
        userId = theUserId;
        shopId = theShopId;
        
        baseUrl = [NSURL URLWithString:BASE];
        manager = [SKObjectManager objectManagerWithApiKey:apiKey andSecret:secret];
        entityURLs = [NSMutableDictionary dictionary];
        
        // set the singleton instance
        if (sharedClient == nil) {
            [SKClient setSharedClient:self];
        }
    }
    return self;
}

- (void)getShopAndOnCompletion:(void (^)(SKShop *, NSError *))completion
{
    NSURL *shopURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shops/%@", BASE, self.shopId]];
    RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKShop class]];
    
    [manager getSingleEntityFromUrl:shopURL withParams:nil intoTargetObject:nil mapping:mapping completion:^(NSArray *objects, NSError *error) {
        SKShop *shop = (SKShop *)[objects objectAtIndex:0];
        [self extractEntityURLs:shop];
        completion(shop, error);
    }];
}

- (void)getUserAndOnCompletion:(void (^)(SKUser *, NSError *))completion
{
    NSURL *userURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", BASE, self.shopId]];
    RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKUser class]];
    
    [manager getSingleEntityFromUrl:userURL withParams:nil intoTargetObject:nil mapping:mapping completion:^(NSArray *objects, NSError *error) {
        SKUser *user = (SKUser *)[objects objectAtIndex:0];
        [self extractEntityURLs:user];
        completion(user, error);
    }];
}


- (void)get:(id)object completion:(void (^)(id, NSError *))completion
{
    [manager get:object completion:^(id loaded, NSError *error) {
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
        NSError *error = [NSError errorWithDomain:SKErrorDomain code:SKURLInferError userInfo:userInfo];
        completion(nil, error);
    }
}

-(void)post:(id)object completion:(void (^)(id, NSError *))completion
{
    NSURL *url = [entityURLs objectForKey:NSStringFromClass([object class])];
    [manager postObject:object toURL:url completion:completion];
}

// takes a shop or user and extracts and remembers
// all URLs for later posting and getting via id of objects
- (void)extractEntityURLs:(id)object
{
    [entityURLs setValue:[object products].url forKey:NSStringFromClass([SKProduct class])];
    [entityURLs setValue:[object designs].url forKey:NSStringFromClass([SKDesign class])];
    [entityURLs setValue:[object baskets].url forKey:NSStringFromClass([SKBasket class])];
    [entityURLs setValue:[object articles].url forKey:NSStringFromClass([SKArticle class])];
    [entityURLs setValue:[object productTypes].url forKey:NSStringFromClass([SKProductType class])];
    [entityURLs setValue:[object currencies].url forKey:NSStringFromClass([SKCurrency class])];
    [entityURLs setValue:[object languages].url forKey:NSStringFromClass([SKLanguage class])];
    [entityURLs setValue:[object countries].url forKey:NSStringFromClass([SKCountry class])];
    [entityURLs setValue:[object printTypes].url forKey:NSStringFromClass([SKPrintType class])];
}

@end
