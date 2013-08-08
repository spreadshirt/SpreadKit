//
//  SPURLConnectionClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import "SPURLConnection.h"
#import "NSURL+PathParameters.h"
#import "SPAuthenticationProvider.h"

@implementation SPURLConnection

+ (void)get:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion
{
    [self sendRequestWithURL:url
                      params:params
                        body:nil
                      apiKey:apiKey
                      secret:secret
                      method:@"GET"
                  completion:completion];
}

+ (void)post:(NSData *)requestData toURL:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *, NSData *, NSError *))completion
{
    [self sendRequestWithURL:url
                      params:params
                        body:requestData
                      apiKey:apiKey
                      secret:secret
                      method:@"POST"
                  completion:completion];
}

+ (void)put:(NSData *)requestData toURL:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *, NSData *, NSError *))completion
{
    [self sendRequestWithURL:url
                     params:params
                        body:requestData
                      apiKey:apiKey
                      secret:secret
                      method:@"PUT"
                  completion:completion];
}

+ (void)delete:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *, NSData *, NSError *))completion
{
    [self sendRequestWithURL:url
                      params:params
                        body:nil
                      apiKey:apiKey
                      secret:secret
                      method:@"DELETE"
                  completion:completion];
}

+ (void)sendRequestWithURL:(NSURL *)url params:(NSDictionary *)passedParams body:(NSData *)data apiKey:(NSString *)apiKey secret:(NSString *)secret method:(NSString *)method completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion
{
    // extract parameters already in url
    NSArray *parameters = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
    for (int i = 0; i < [parameters count]; i=i+2) {
        [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
    }

    // strip duplicate params from passed params
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:passedParams];
    [keyValueParm enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([params.allKeys containsObject:key]) {
            [params removeObjectForKey:key];
        }
    }];
    
    // build url with params
    NSURL *configuredURL = [url URLByAppendingParameters:params];
    
    // calculate authorization header
    NSString *authorizationHeader = [SPAuthenticationProvider authorizationHeaderFromApiKey:apiKey andSecret:secret andURL:configuredURL.absoluteString andMethod:method andSessionId:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:configuredURL];
    request.HTTPMethod = method;
    request.HTTPBody = data;
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:completion];
}

@end
