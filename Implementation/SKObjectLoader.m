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

@implementation SKObjectLoader

- (void)loadSingleEntityFromUrl:(NSURL *)url mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    // temporary mapping provider without root element
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    [self loadResourceFromUrl:url mappingProvdider:prov onSucess:success onFailure:failure];
}

- (void)loadEntityListFromUrl:(NSURL *)url onSucess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    RKObjectMappingProvider *prov = [SKObjectMappingProvider sharedMappingProvider];
    [self loadResourceFromUrl:url mappingProvdider:prov onSucess:success onFailure:failure];
}

- (void)loadResourceFromUrl:(NSURL *)theUrl mappingProvdider:(RKObjectMappingProvider *)mappingProvider onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure
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
        
        id mappingResult = [[SKObjectMapper mapperWithMIMEType:response.MIMEType data:data mappingProvider:mappingProvider] performMapping];
        
        success(mappingResult);
    }];
}

@end
