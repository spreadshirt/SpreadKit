//
//  SKClient.h
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class SKUser;
@class SKShop;

@interface SKClient : NSObject

// The Spreadshirt API key to be used to access protected resources.
@property (strong, readonly) NSString *apiKey;

// The secret corresponding to the API key.
@property (strong, readonly) NSString *secret;

// The User ID as which the Spreadshirt API is accessed.
@property (strong, readonly) NSString *userId;

// The Shop ID for all operations to the Spreadshirt API.
@property (strong, readonly) NSString *shopId;

// Return the shared instance of the client.
+ (SKClient *)sharedClient;

// Set the shared instance of the client.
+ (void)setSharedClient:(SKClient *)client;

// Return a client scoped to a particular shop. If the singleton is nil,
// the return client is set as the singleton.
+ (SKClient *)clientWithShopId:(NSString *)shopId
                     andApiKey:(NSString *)apiKey
                     andSecret:(NSString *)secret;

// Return a client scoped to a particular user. If the singleton is nil,
// the return client is set as the singleton.
+ (SKClient *)clientWithUserId:(NSString *)userId
                    andApiKey:(NSString *)apiKey
                     andSecret:(NSString *)secret;

// gets the user entity of a user-scoped client
- (void)loadUserAndOnSuccess:(void (^)(SKUser *user))success onFailure:(void (^)(NSError *error))failure;

// gets the shop entity of a shop-scoped client
- (void)loadShopAndOnSuccess:(void (^)(SKShop *shop))success onFailure:(void (^)(NSError *error))failure;

- (void)load:(id)object onSuccess:(void (^)(id loadedObject))success onFailure:(void (^)(NSError *error))failure;

@end
