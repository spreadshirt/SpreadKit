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
        [self loadEntityListFromUrl:[el url] onSucess:^(NSArray *objects) {
            el.elements = [NSSet setWithArray:objects];
            success(el);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } else {
        [self loadSingleObjectStub:objectStub onSuccess:^(id loaded) {
            success(loaded);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)loadSingleObjectStub:(id)theStub onSuccess:(void (^)(id))sucess onFailure:(void (^)(NSError *))failure
{
    if ([theStub respondsToSelector:@selector(url)]) { 
        RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[theStub class]];
        [self loadSingleEntityFromUrl:[theStub url] intoTargetObject:theStub mapping:mapping onSucess:^(NSArray *objects) {
            sucess([objects objectAtIndex:0]);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } else {
        failure([NSError errorWithDomain:@"SK" code:-1 userInfo:nil]);
    }
}

- (void)loadSingleEntityFromUrl:(NSURL *)url intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    // temporary mapping provider without root element
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    [self loadResourceFromUrl:url mappingProvdider:prov intoTargetObject:target onSucess:success onFailure:failure];
}

- (void)loadEntityListFromUrl:(NSURL *)url onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    RKObjectMappingProvider *prov = [SKObjectMappingProvider sharedMappingProvider];
    [self loadResourceFromUrl:url mappingProvdider:prov intoTargetObject:nil onSucess:success onFailure:failure];
}

- (void)loadResourceFromUrl:(NSURL *)theUrl mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    NSString *configuredUrl = [theUrl.absoluteString appendQueryParams:[NSDictionary dictionaryWithKeysAndObjects:
                                                                        @"mediaType", @"json",
                                                                        @"fullData", @"true",
                                                                        nil]];
    
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
