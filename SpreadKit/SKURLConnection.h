//
//  SKURLConnectionClient.h
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import <Foundation/Foundation.h>

@interface SKURLConnection : NSObject


+ (void)get:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion;

+ (void)post:(NSData *)requestData toURL:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion;

+ (void)put:(NSData *)requestData toURL:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion;

+ (void)delete:(NSURL *)url params:(NSDictionary *)params apiKey:(NSString *)apiKey secret:(NSString *)secret completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion;

@end
