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
#import "RestKit/NSURL+RestKit.h"
#import "SKClient.h"

@implementation SKObjectLoader

- (void)load:(id)objectStub onSuccess:(void (^)(id loadedObject))success onFailure:(void (^)(NSError *))failure
{
    if ([objectStub isMemberOfClass:[SKEntityList class]]) {
        SKEntityList *el = (SKEntityList *)objectStub;
        [self loadEntityList:el onSuccess:^(NSArray *objects) {
            el.elements = [NSSet setWithArray:objects];
            success(el);
        } onFailure:failure];
    } else {
        [self loadSingleObjectStub:objectStub onSuccess:success onFailure:failure];
    }
}

- (void)loadSingleObjectStub:(id)theStub onSuccess:(void (^)(id))sucess onFailure:(void (^)(NSError *))failure
{
    if ([theStub respondsToSelector:@selector(url)]) { 
        RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[theStub class]];
        [self loadSingleEntityFromUrl:[theStub url] withParams:nil intoTargetObject:theStub mapping:mapping onSucess:^(NSArray *objects) {
            sucess([objects objectAtIndex:0]);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } else {
        failure([NSError errorWithDomain:@"SK" code:-1 userInfo:nil]);
    }
}

- (void)loadEntityList:(SKEntityList *)list onSuccess:(void (^)(NSArray *))sucess onFailure:(void (^)(NSError *))failure
{
    NSString *offset = [list.offset stringValue];
    NSString *limit = [list.limit stringValue];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: offset, @"offset", limit, @"limit", nil];
    [self loadSingleEntityFromUrl:list.url withParams:params intoTargetObject:list mapping:[[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKEntityList class]] onSucess:^ (NSArray *objects) {
        [self loadEntityListFromUrl:list.url withParams:params onSucess:sucess onFailure:failure];
    } onFailure:failure];
}

- (void)loadSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    // temporary mapping provider without root element
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    [self loadResourceFromUrl:url withParams:params mappingProvdider:prov intoTargetObject:target onSucess:success onFailure:failure];
}

- (void)loadEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    RKObjectMappingProvider *prov = [SKObjectMappingProvider sharedMappingProvider];
    [self loadResourceFromUrl:url withParams:params mappingProvdider:prov intoTargetObject:nil onSucess:success onFailure:failure];
}

- (void)loadResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)passedParams mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                   @"mediaType", @"json", 
                                   @"fullData", @"true",
                                   nil];
    if (passedParams) {
        [params addEntriesFromDictionary:passedParams];
    }
    
    [[theUrl queryDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([params.allKeys containsObject:key]) {
            [params removeObjectForKey:key];
        }
    }];
    
    NSURL *configuredURL = [theUrl URLByAppendingParameters:params];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:configuredURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        // remember server time offset to sign SprdAuth requests correctly
        [SKClient sharedClient].serverTimeOffset = [self getServerTimeOffset:(NSHTTPURLResponse *)response];
        
        id mappingResult = [[SKObjectMapper mapperWithMIMEType:response.MIMEType mappingProvider:mappingProvider andDestinationObject:target] 
                            performMappingWithData:data];
        success(mappingResult);
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
