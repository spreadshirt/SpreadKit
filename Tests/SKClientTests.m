//
//  SKClientTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SpreadKit.h"

@interface SKClientTests : GHTestCase
@end

@implementation SKClientTests

- (void)setUpClass
{
    [SKClient setSharedClient:nil];
}

- (void)tearDownClass
{
    [SKClient setSharedClient:nil];
}

- (void)testClientInitialization
{
    SKClient *client = [SKClient sharedClient];
    GHAssertNil(client, @"Shared client should be nil at the beginning");
    
    // initialize the shared client
    
    client = [SKClient clientWithShopId:@"foo" 
                              andApiKey:@"bar" 
                              andSecret:@"baz"];
    
    GHAssertNotNil(client, @"Local client should be initialized");
    GHAssertNotNil(client, @"Shared client should have been set");
    GHAssertEqualObjects(client, [SKClient sharedClient], @"Shared client should be the newly initialized client");
    
    GHAssertEqualStrings(client.apiKey, @"bar", @"Client should have the right API key");
    GHAssertEqualStrings(client.secret, @"baz", @"Client should have the right secret");
    GHAssertNil(client.userId, @"Client should have the right no user ID");
    GHAssertEqualStrings(client.shopId, @"foo", @"Client should have the right shop ID");
    
    // initialize another client
    client = [SKClient clientWithUserId:@"" andApiKey:@"" andSecret:@""];
    GHAssertNotEqualObjects(client, [SKClient sharedClient], @"Shared client should not have been overriden by new instance");
}

- (void)testDirectIdLoading
{
    SKClient *client = [SKClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx"];
    [client getShopAndOnCompletion:^(SKShop *shop, NSError *error) {
        GHAssertNil(error, nil);
        [client get:[SKProductType class] identifier:@"6" completion:^(id loadedObject, NSError *error) {
            GHAssertNil(error, nil);
            GHAssertNotNil(loadedObject, nil);
        }];
        [client get:[SKResource class] identifier:@"foo" completion:^(id loadedObject, NSError *error) {
            GHAssertNotNil(error, nil);
        }];
    }];
}

- (void)tearDown
{
    [SKClient setSharedClient:nil];
}

@end
