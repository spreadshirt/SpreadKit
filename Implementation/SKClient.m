//
//  SKClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKClient.h"
#import "SKObjectMappingProvider.h"

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
