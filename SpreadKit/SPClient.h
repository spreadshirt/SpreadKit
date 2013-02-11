//
//  SPClient.h
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPUser;
@class SPShop;
@class SPEntityList;

@interface SPClient : NSObject

// The Spreadshirt API key to be used to access protected resources.
@property (strong, readonly) NSString *apiKey;

// The secret corresponding to the API key.
@property (strong, readonly) NSString *secret;

// The User ID as which the Spreadshirt API is accessed.
@property (strong, readonly) NSString *userId;

// The Shop ID for all operations to the Spreadshirt API.
@property (strong, readonly) NSString *shopId;

// The Platform of the client, valid Values are SPPlatformEU and SPPlatformNA
@property (strong, readonly) NSString *platform;

@property (strong, readonly) NSString *baseURL;

// Return the shared instance of the client.
+ (SPClient *)sharedClient;

// Set the shared instance of the client.
+ (void)setSharedClient:(SPClient *)client;

// Return a client scoped to a particular user and a specified Spreadshirt platform.
// If the singleton is nil, the return client is set as the singleton.
+ (SPClient *)clientWithUserId:(NSString *)userId
                     andApiKey:(NSString *)apiKey
                     andSecret:(NSString *)secret
                   andPlatform:(NSString *)platform;

// Return a client scoped to a particular shop and a specified Spreadshirt platform.
// If the singleton is nil, the return client is set as the singleton.
+ (SPClient *)clientWithShopId:(NSString *)shopId
                     andApiKey:(NSString *)apiKey
                     andSecret:(NSString *)secret
                   andPlatform:(NSString *)platform;

// gets the user entity of a user-scoped client
- (void)getUserAndOnCompletion:(void (^)(SPUser *user, NSError *error))completion;

// gets the shop entity of a shop-scoped client
- (void)getShopAndOnCompletion:(void (^)(SPShop *shop, NSError *error))completion;

// gets the full details of an object
- (void)get:(id)object completion:(void (^)(id loadedObject, NSError *error))completion;

// gets an object with just the class and id known
- (void)get:(Class)classOfObject identifier:(NSString *)identifier completion:(void (^)(id loadedObject, NSError *error))completion;

// gets a list of all (!) objects of a certian class
- (void)getAll:(Class)classOfObjects completion:(void (^)(SPEntityList *objects, NSError *error))completion;

// posts a new object and sets the url of the created object into the url property
- (void)post:(id)object completion:(void (^)(id newObject, NSError *error))completion;

// updates an existing entity
- (void)put:(id)object completion:(void (^)(id updatedObject, NSError *error))completion;

@end
