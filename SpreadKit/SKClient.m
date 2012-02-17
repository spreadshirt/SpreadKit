//
//  SKClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKClient.h"

static SKClient *sharedClient = nil;

@implementation SKClient

@synthesize apiKey, shopId, userId, secret;

+ (SKClient *)sharedClient
{
    return sharedClient;
}

+ (void)setSharedClient:(SKClient *)client
{
    sharedClient = client;
}

+ (SKClient *)clientWithApiKey:(NSString *)theApiKey 
                     andSecret:(NSString *)theSecret 
                     andUserId:(NSString *)theUserId 
                     andShopId:(NSString *)theShopId 
{
    SKClient *client = [[self alloc] initWithApiKey:theApiKey 
                                          andSecret:theSecret 
                                          andUserId:theUserId 
                                          andShopId:theShopId];
    return client;
}

- (id)init
{
    self = [super init];
    if (self) {
        // initialization code here...
        
        // initialize object model
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // initialize object context
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        
        // database name is app name
        NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        // initialize database
        NSError *error;
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        
        // initialize the object manager
        objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://api.spreadshirt.net/api/v1"];
        RKManagedObjectStore *store = [RKManagedObjectStore objectStoreWithStoreFilename:@"SpreadKitTests.sqlite"];
        objectManager.objectStore = store;
        
    }
    return self;
}

- (id)initWithApiKey:(NSString *)theApiKey 
           andSecret:(NSString *)theSecret 
           andUserId:(NSString *)theUserId
           andShopId:(NSString *)theShopId
{
    self = [self init];
    if (self) {
        self.apiKey = theApiKey;
        self.secret = theSecret;
        self.userId = theUserId;
        self.shopId = theShopId;
        
        // set the singleton instance
        if (sharedClient == nil) {
            [SKClient setSharedClient:self];
        }
    }
    return self;
}

@end
