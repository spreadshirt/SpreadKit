//
//  SPObjectManager.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import "SPObjectManager.h"
#import "SPList.h"
#import "SPObjectMappingProvider.h"
#import "SPURLConnection.h"
#import "SPObjectMapper.h"
#import "SPConstants.h"

@implementation SPObjectManager
{
    NSMutableDictionary *defaultParams;
}

@synthesize apiKey, secret, serverTimeOffset;

+ (SPObjectManager *)objectManagerWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    return [[self alloc] initWithApiKey:apiKey andSecret:secret];
}

- (id)init
{
    if (self = [super init]) {
        defaultParams = [NSMutableDictionary dictionaryWithKeysAndObjects:@"mediaType", @"json", @"fullData", @"true", nil];
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

- (void)getObject:(id)objectStub params:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    if ([objectStub isMemberOfClass:[SPList class]]) {
        SPList *el = (SPList *)objectStub;
        [self getList:el params:params completion:^(NSArray *elements, NSError *error) {
            completion(elements, error);
        }];
    } else if ([objectStub isMemberOfClass:[SPListPage class]]) {
        [self getListPage:objectStub params:params completion:^(NSArray *elements, NSError *error) {
            completion(elements, error);
        }];
    } else {
        [self getSingleObjectStub:objectStub params:params completion:^(id loaded, NSError *error) {
            completion(loaded, error);
        }];
    }
}

- (void)getListPage:(SPListPage *)page params:(NSDictionary *)params completion:(void (^)(NSArray *elements, NSError *error))completion
{
    int offset = page.list.limit.integerValue * (page.page - 1);
    
    NSMutableDictionary *listPageParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [listPageParams addEntriesFromDictionary:@{@"offset": [NSString stringWithFormat:@"%d", offset], @"limit": page.list.limit.stringValue}];
    
    [self getListFromUrl:page.list.url withParams:listPageParams completion:^(NSArray *elements, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            page.list.elements = [page.list.elements arrayByAddingObjectsFromArray:elements];
            completion(elements, nil);
        }
    }];
}

- (void)getSingleObjectStub:(id)theStub params:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    if ([theStub respondsToSelector:@selector(url)]) {
        [self getSingleEntityFromUrl:[theStub url] withParams:params intoTargetObject:theStub entityClass:[theStub class] completion:^(NSArray *objects, NSError *error) {
            completion([objects objectAtIndex:0], error);
        }];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"The object could not be loaded because there it has no URL." forKey:NSLocalizedDescriptionKey];
        completion(nil, [NSError errorWithDomain:SPErrorDomain code:SPURLMissingError userInfo:userInfo]);
    }
}

- (void)getList:(SPList *)list params:(NSDictionary *)params completion:(void (^)(NSArray *elements, NSError *error))completion
{
    [self getSingleEntityFromUrl:list.url withParams:params intoTargetObject:list entityClass:[SPList class] completion:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self getListPage:list.current params:params completion:^(NSArray *elements, NSError *error) {
                if (!error) {
                    completion(elements, nil);
                } else {
                    completion(nil, error);
                }
            }];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)getSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target entityClass:(Class)class completion:(void (^)(NSArray *, NSError *))completion
{
    [self getResourceFromUrl:url withParams:params resourceClass:class intoTargetObject:target completion:completion];
}

- (void)getListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion
{
    [self getResourceFromUrl:url withParams:params resourceClass:nil intoTargetObject:nil completion:completion];
}

- (void)getResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)passedParams resourceClass:(Class)class intoTargetObject:(id)target completion:(void (^)(NSArray *, NSError *))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:defaultParams];
    if (passedParams) {
        [params addEntriesFromDictionary:passedParams];
    }
    
    [SPURLConnection get:theUrl params:params apiKey:apiKey secret:secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // remember server time offset to sign SprdAuth requests correctly
        serverTimeOffset = [self getServerTimeOffset:(NSHTTPURLResponse *)response];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[ message, @"Getting object failed" ] forKeys:@[ SPErrorMessageKey, NSLocalizedDescriptionKey ]];
            
            NSError *error = [NSError errorWithDomain:SPErrorDomain code:SPPostFailedError userInfo:userInfo];
            completion(nil, error);
        } else {
            
            // map and return the result
            
            id mappingResult = [[SPObjectMapper mapperWithMIMEType:response.MIMEType objectClass:class andDestinationObject:target]
                                performMappingWithData:data];
            
            completion(mappingResult, nil);
        }
    }];
}

- (NSData *)requestDataFromObject:(id)theObject
{
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:RKMIMETypeJSON objectClass:[theObject class]];
    NSString *json = [mapper serializeObject:theObject];
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return requestData;
}

- (void)postObject:(id)theObject toURL:(NSURL *)theURL completion:(void (^)(id, NSError *))completion
{
    NSData *requestData;
    requestData = [self requestDataFromObject:theObject];
    
    [SPURLConnection post:requestData toURL:theURL params:defaultParams apiKey:apiKey secret:secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 201) {
                [theObject setUrl:[NSURL URLWithString:[[httpResponse allHeaderFields] objectForKey:@"Location"]]];
                completion(theObject, nil);
            } else {
                NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[ message, @"Posting object failed" ] forKeys:@[ SPErrorMessageKey, NSLocalizedDescriptionKey ]];
                
                NSError *error = [NSError errorWithDomain:SPErrorDomain code:SPPostFailedError userInfo:userInfo];
                completion(nil, error);
            }
        }
    }];
}

- (void)putObject:(id)theObject completion:(void (^)(id, NSError *))completion
{
    [SPURLConnection put:[self requestDataFromObject:theObject] toURL:[theObject url] params:defaultParams apiKey:apiKey secret:secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                completion(theObject, nil);
            } else {
                NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[ message, @"Updating object failed" ] forKeys:@[ SPErrorMessageKey, NSLocalizedDescriptionKey ]];
                
                NSError *error = [NSError errorWithDomain:SPErrorDomain code:SPPostFailedError userInfo:userInfo];
                completion(theObject, error);
            }
        }
    }];
}

- (void)deleteObject:(id)theObject completion:(void (^)(NSError *))completion
{
    [SPURLConnection delete:[theObject url]
                     params:defaultParams
                     apiKey:apiKey
                     secret:secret
                 completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                     
                     if (error) {
                         completion(error);
                     } else {
                         completion(nil);
                     }
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

- (void)setLocale:(NSLocale *)locale
{
    _locale = locale;
    [defaultParams setObject:locale.localeIdentifier forKey:@"locale"];
}

@end
