//
//  SKObjectPoster.m
//  SpreadKit
//
//  Created by Sebastian Marr on 11.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKObjectPoster.h"
#import "SKObjectMapper.h"
#import "SKAuthenticationProvider.h"
#import "SKBasket.h"

@implementation SKObjectPoster

- (void)postObject:(id)theObject toURL:(NSURL *)theURL mappingProvider:(RKObjectMappingProvider *)mappingProvider onSuccess:(void (^)(id object))success onFailure:(void (^)(NSError *error))failure
{
    // map the object to json
    SKObjectMapper *mapper = [SKObjectMapper mapperWithMIMEType:RKMIMETypeJSON mappingProvider:mappingProvider];
    NSString *json = [mapper serializeObject:theObject];
    
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    [request setValue:[SKAuthenticationProvider authorizationHeaderFromApiKey:@"xxx" andSecret:@"4b7421c1-aeca-4685-b09b-87aa846a3bcb" andURL:[theURL absoluteString] andMethod:request.HTTPMethod andTimeStamp:@"1337592528" andSessionId:nil] forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            failure(error);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 201) {
            [theObject setUrl:[NSURL URLWithString:[[httpResponse allHeaderFields] objectForKey:@"Location"]]];
        }
        success(theObject);
    }];
}

@end
