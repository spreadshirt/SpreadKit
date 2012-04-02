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

@interface SKClient : NSObject
{
    // The Core Data object model
    NSManagedObjectModel *managedObjectModel;
    // The Core Data object context
    NSManagedObjectContext *managedObjectContext;
    // The RestKit object manager
    RKObjectManager *objectManager;
}

// The Spreadshirt API key to be used to access protected resources.
@property (strong) NSString *apiKey;

// The secret corresponding to the API key.
@property (strong) NSString *secret;

// The User ID as which the Spreadshirt API is accessed.
@property (strong) NSString *userId;

// The Shop ID for all operations to the Spreadshirt API.
@property (strong) NSString *shopId;

// Return the shared instance of the client.
+ (SKClient *)sharedClient;

// Set the shared instance of the client.
+ (void)setSharedClient:(SKClient *)client;

// Return a client scoped to a particular user and shop. If the singleton is nil,
// the return client is set as the singleton.
+ (SKClient *)clientWithApiKey:(NSString *)theApiKey
                     andSecret:(NSString *)theSecret
                     andUserId:(NSString *)theUserId
                     andShopId:(NSString *)theShopId;

// Return a client scoped to a particular user and shop. If the singleton is nil,
// the return client is set as the singleton.
- (id)initWithApiKey:(NSString *)theApiKey
           andSecret:(NSString *)theSecret
           andUserId:(NSString *)theUserId
           andShopId:(NSString *)theShopId;

@end
