//
//  SPClientTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SpreadKit.h"

@interface SPClientTests : GHTestCase
@end

@implementation SPClientTests

- (void)setUpClass
{
    [SPClient setSharedClient:nil];
}

- (void)tearDownClass
{
    [SPClient setSharedClient:nil];
}

- (void)testClientInitialization
{
    SPClient *client = [SPClient sharedClient];
    GHAssertNil(client, @"Shared client should be nil at the beginning");
    
    // initialize the shared client
    
    client = [SPClient clientWithShopId:@"foo"
                              andApiKey:@"bar" 
                              andSecret:@"baz"];
    
    GHAssertNotNil(client, @"Local client should be initialized");
    GHAssertNotNil(client, @"Shared client should have been set");
    GHAssertEqualObjects(client, [SPClient sharedClient], @"Shared client should be the newly initialized client");
    
    GHAssertEqualStrings(client.apiKey, @"bar", @"Client should have the right API key");
    GHAssertEqualStrings(client.secret, @"baz", @"Client should have the right secret");
    GHAssertNil(client.userId, @"Client should have the right no user ID");
    GHAssertEqualStrings(client.shopId, @"foo", @"Client should have the right shop ID");
    
    // initialize another client
    client = [SPClient clientWithUserId:@"" andApiKey:@"" andSecret:@""];
    GHAssertNotEqualObjects(client, [SPClient sharedClient], @"Shared client should not have been overriden by new instance");
}

- (void)testDirectIdLoading
{
    SPClient *client = [SPClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx"];
    [client getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
        GHAssertNil(error, nil);
        [client get:[SPProductType class] identifier:@"6" completion:^(id loadedObject, NSError *error) {
            GHAssertNil(error, nil);
            GHAssertNotNil(loadedObject, nil);
        }];
        [client get:[SPResource class] identifier:@"foo" completion:^(id loadedObject, NSError *error) {
            GHAssertNotNil(error, nil);
        }];
    }];
}

- (void)tearDown
{
    [SPClient setSharedClient:nil];
}

@end
