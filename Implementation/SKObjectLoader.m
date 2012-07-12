//
//  SKObjectLoader.m
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectLoader.h"
#import "RestKit/RKObjectMapper_Private.h"
#import "SKObjectMappingProvider.h"
#import "SKObjectMapper.h"
#import "SKEntityList.h"
#import "NSURL+PathParameters.h"
#import "SKClient.h"

@implementation SKObjectLoader

- (void)load:(id)objectStub completion:(void (^)(id, NSError *))completion
{
    if ([objectStub isMemberOfClass:[SKEntityList class]]) {
        SKEntityList *el = (SKEntityList *)objectStub;
        [self loadEntityList:el completion:^(SKEntityList *list, NSError *error) {
            completion(list, error);
        }];
    } else {
        [self loadSingleObjectStub:objectStub completion:completion];
    }
}

- (void)loadSingleObjectStub:(id)theStub completion:(void (^)(id, NSError *))completion
{
    if ([theStub respondsToSelector:@selector(url)]) { 
        RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[theStub class]];
        [self loadSingleEntityFromUrl:[theStub url] withParams:nil intoTargetObject:theStub mapping:mapping completion:^(NSArray *objects, NSError *error) {
            completion([objects objectAtIndex:0], error);
        }];
    } else {
        completion(nil, [NSError errorWithDomain:@"SK" code:-1 userInfo:nil]);
    }
}

- (void)loadEntityList:(SKEntityList *)list completion:(void (^)(SKEntityList *, NSError *))completion
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
    
    [self loadSingleEntityFromUrl:list.url withParams:params intoTargetObject:list mapping:[[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKEntityList class]] completion:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self loadEntityListFromUrl:list.url withParams:params completion:^(NSArray *objects, NSError *error) {
                list.elements = [NSSet setWithArray:objects];
                completion(list, nil);
            }];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)loadSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *, NSError *))completion
{
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    [self loadResourceFromUrl:url withParams:params mappingProvdider:prov intoTargetObject:target completion:completion];
}

- (void)loadEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion
{
    RKObjectMappingProvider *prov = [SKObjectMappingProvider sharedMappingProvider];
    [self loadResourceFromUrl:url withParams:params mappingProvdider:prov intoTargetObject:nil completion:completion];
}

- (void)loadResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)passedParams mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target completion:(void (^)(NSArray *, NSError *))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                   @"mediaType", @"json", 
                                   @"fullData", @"true",
                                   nil];
    if (passedParams) {
        [params addEntriesFromDictionary:passedParams];
    }
    
    [[theUrl queryParameters] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([params.allKeys containsObject:key]) {
            [params removeObjectForKey:key];
        }
    }];
    
    NSURL *configuredURL = [theUrl URLByAppendingParameters:params];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:configuredURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // remember server time offset to sign SprdAuth requests correctly
        [SKClient sharedClient].serverTimeOffset = [self getServerTimeOffset:(NSHTTPURLResponse *)response];
        
        id mappingResult = [[SKObjectMapper mapperWithMIMEType:response.MIMEType mappingProvider:mappingProvider andDestinationObject:target] 
                            performMappingWithData:data];
        completion(mappingResult, nil);
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
