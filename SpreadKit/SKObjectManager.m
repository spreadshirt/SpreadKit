//
//  SKObjectManager.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import "SKObjectManager.h"
#import "SKEntityList.h"
#import "SKObjectMappingProvider.h"
#import "SKURLConnection.h"
#import "SKObjectMapper.h"
#import "Constants.h"

@implementation SKObjectManager
{
    NSDictionary *defaultParams;
}

@synthesize apiKey, secret, serverTimeOffset;

+ (SKObjectManager *)objectManagerWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    return [[self alloc] initWithApiKey:apiKey andSecret:secret];
}

- (id)init
{
    if (self = [super init]) {
        defaultParams = [NSDictionary dictionaryWithKeysAndObjects:@"mediaType", @"json", @"fullData", @"true", nil];
    }
    return self;
}

- (id)initWithApiKey:(NSString *)theApiKey andSecret:(NSString *)theSecret
{
    if (self = [self init]) {
        apiKey = theApiKey;
        secret = theSecret;
    }
    return self;
}

- (void)get:(id)objectStub completion:(void (^)(id, NSError *))completion
{
    if ([objectStub isMemberOfClass:[SKEntityList class]]) {
        SKEntityList *el = (SKEntityList *)objectStub;
        [self getEntityList:el completion:^(SKEntityList *list, NSError *error) {
            completion(list, error);
        }];
    } else {
        [self getSingleObjectStub:objectStub completion:completion];
    }
}

- (void)getSingleObjectStub:(id)theStub completion:(void (^)(id, NSError *))completion
{
    if ([theStub respondsToSelector:@selector(url)]) {
        RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[theStub class]];
        [self getSingleEntityFromUrl:[theStub url] withParams:nil intoTargetObject:theStub mapping:mapping completion:^(NSArray *objects, NSError *error) {
            completion([objects objectAtIndex:0], error);
        }];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"The object could not be loaded because there it has no URL." forKey:NSLocalizedDescriptionKey];
        completion(nil, [NSError errorWithDomain:SKErrorDomain code:SKURLMissingError userInfo:userInfo]);
    }
}

- (void)getEntityList:(SKEntityList *)list completion:(void (^)(SKEntityList *, NSError *))completion
{
    NSString *offset = [list.offset stringValue];
    NSString *limit = [list.limit stringValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (offset) {
        [params setObject:offset forKey:@"offset"];
    }
    if (limit) {
        [params setObject:limit forKey:@"limit"];
    }
    
    [self getSingleEntityFromUrl:list.url withParams:params intoTargetObject:list mapping:[[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKEntityList class]] completion:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self getEntityListFromUrl:list.url withParams:params completion:^(NSArray *objects, NSError *error) {
                list.elements = objects;
                completion(list, nil);
            }];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)getSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *, NSError *))completion
{
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    [self getResourceFromUrl:url withParams:params mappingProvdider:prov intoTargetObject:target completion:completion];
}

- (void)getEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion
{
    RKObjectMappingProvider *prov = [SKObjectMappingProvider sharedMappingProvider];
    [self getResourceFromUrl:url withParams:params mappingProvdider:prov intoTargetObject:nil completion:completion];
}

- (void)getResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)passedParams mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target completion:(void (^)(NSArray *, NSError *))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:defaultParams];
    if (passedParams) {
        [params addEntriesFromDictionary:passedParams];
    }
    
    [SKURLConnection get:theUrl params:params apiKey:apiKey secret:secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // remember server time offset to sign SprdAuth requests correctly
        serverTimeOffset = [self getServerTimeOffset:(NSHTTPURLResponse *)response];
        
        id mappingResult = [[SKObjectMapper mapperWithMIMEType:response.MIMEType mappingProvider:mappingProvider andDestinationObject:target]
                            performMappingWithData:data];
        completion(mappingResult, nil);
    }];
}

- (void)postObject:(id)theObject toURL:(NSURL *)theURL completion:(void (^)(id, NSError *))completion
{
    SKObjectMappingProvider *mappingProvider = [SKObjectMappingProvider sharedMappingProvider];
    SKObjectMapper *mapper = [SKObjectMapper mapperWithMIMEType:RKMIMETypeJSON mappingProvider:mappingProvider];
    NSString *json = [mapper serializeObject:theObject];
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [SKURLConnection post:requestData toURL:theURL params:defaultParams apiKey:apiKey secret:secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 201) {
            [theObject setUrl:[NSURL URLWithString:[[httpResponse allHeaderFields] objectForKey:@"Location"]]];
            completion(theObject, nil);
        }
        completion(nil, nil);
    }];
}

- (int)getServerTimeOffset:(NSHTTPURLResponse *)response
{
    id dateString = [[response allHeaderFields] objectForKey:@"Date"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *serverTime = [df dateFromString:dateString];
    return [[NSDate date] timeIntervalSinceDate:serverTime];
}

@end
