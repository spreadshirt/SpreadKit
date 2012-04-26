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

- (void)loadResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)theParams mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithKeysAndObjects:@"mediaType", @"json", nil];
    if (theParams) {
        [params addEntriesFromDictionary:theParams];
    }
    NSString *configuredUrl = [theUrl.absoluteString appendQueryParams:params];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:configuredUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        id mappingResult = [[SKObjectMapper mapperWithMIMEType:response.MIMEType data:data mappingProvider:mappingProvider andDestinationObject:target] performMapping];
        success(mappingResult);
    }];
    
}

@end
