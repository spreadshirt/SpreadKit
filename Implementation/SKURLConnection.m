//
//  SKURLConnectionClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import "SKURLConnection.h"
#import <RestKit/NSURL+RKAdditions.h>
#import "NSURL+PathParameters.h"

@implementation SKURLConnection

+ (void)get:(NSURL *)url params:(NSDictionary *)params authorizationHeader:(NSString *)authorizationHeader completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion
{
    [self sendRequestWithURL:url
                      params:params
                        body:nil
         authorizationHeader:authorizationHeader
                      method:@"GET"
                  completion:completion];
}

+ (void)post:(NSData *)requestData toURL:(NSURL *)url params:(NSDictionary *)params authorizationHeader:(NSString *)authorizationHeader completion:(void (^)(NSURLResponse *, NSData *, NSError *))completion
{
    [self sendRequestWithURL:url
                      params:params
                        body:requestData
         authorizationHeader:authorizationHeader
                      method:@"POST"
                  completion:completion];
}

+ (void)put:(NSData *)requestData toURL:(NSURL *)url params:(NSDictionary *)params authorizationHeader:(NSString *)authorizationHeader completion:(void (^)(NSURLResponse *, NSData *, NSError *))completion
{
    [self sendRequestWithURL:url
                     params:params
                        body:requestData
         authorizationHeader:authorizationHeader
                      method:@"PUT"
                  completion:completion];
}

+ (void)delete:(NSURL *)url params:(NSDictionary *)params authorizationHeader:(NSString *)authorizationHeader completion:(void (^)(NSURLResponse *, NSData *, NSError *))completion
{
    [self sendRequestWithURL:url
                      params:params
                        body:nil
         authorizationHeader:authorizationHeader
                      method:@"DELETE"
                  completion:completion];
}

+ (void)sendRequestWithURL:(NSURL *)url params:(NSDictionary *)passedParams body:(NSData *)data authorizationHeader:(NSString *)authorizationHeader method:(NSString *)method completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion
{
    // strip params already contained in url
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:passedParams];
    [url.queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([params.allKeys containsObject:key]) {
            [params removeObjectForKey:key];
        }
    }];
    
    // build url with params
    NSURL *configuredURL = [url URLByAppendingParameters:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:configuredURL];
    request.HTTPMethod = method;
    request.HTTPBody = data;
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:completion];
}

@end
