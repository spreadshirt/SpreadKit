//
//  SKClient.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKClient.h"
#import "SKObjectMappingProvider.h"
#import "SKObjectLoader.h"
#import "SKProduct.h"

static SKClient *sharedClient = nil;
NSString * const BASE = @"http://api.spreadshirt.net/api/v1";

@implementation SKClient
{
    NSURL *baseUrl;
}

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
        
        baseUrl = [NSURL URLWithString:BASE];
        
        // set the singleton instance
        if (sharedClient == nil) {
            [SKClient setSharedClient:self];
        }
    }
    return self;
}

- (void)loadShopProductsAndOnSuccess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    SKObjectLoader *loader = [[SKObjectLoader alloc] init];
    RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKProduct class]];
    NSURL *productsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shops/%@/products",BASE,self.shopId]];
    
    [loader loadEntityListFromUrl:[productsUrl absoluteString] mapping:mapping onSucess:^(NSArray *objects) {
        success(objects);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

@end
