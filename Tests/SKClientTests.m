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

- (void)testClientInitialization
{
    SKClient *client = [SKClient sharedClient];
    GHAssertNil(client, @"Shared client should be nil at the beginning");
    
    // initialize the shared client
    client = [SKClient clientWithApiKey:@"foo" 
                              andSecret:@"bar"
                              andUserId:@"bat" 
                              andShopId:@"baz"];
    GHAssertNotNil(client, @"Local client should be initialized");
    GHAssertNotNil(client, @"Shared client should have been set");
    GHAssertEqualObjects(client, [SKClient sharedClient], @"Shared client should be the newly initialized client");
    
    GHAssertEqualStrings(client.apiKey, @"foo", @"Client should have the right API key");
    GHAssertEqualStrings(client.secret, @"bar", @"Client should have the right secret");
    GHAssertEqualStrings(client.userId, @"bat", @"Client should have the right user ID");
    GHAssertEqualStrings(client.shopId, @"baz", @"Client should have the right shop ID");
    
    // initialize another client
    client = [SKClient clientWithApiKey:@"" 
                              andSecret:@"" 
                              andUserId:@"" 
                              andShopId:@""];
    GHAssertNotEqualObjects(client, [SKClient sharedClient], @"Shared client should not have been overriden by new instance");
}

- (void)tearDown
{
    [SKClient setSharedClient:nil];
}

@end
