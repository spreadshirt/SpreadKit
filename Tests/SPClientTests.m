//
//  SPClientTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "SpreadKit.h"

@interface SPClientTests : GHTestCase
{
    SPClient *client;
}
@end

@implementation SPClientTests

- (void)setUpClass
{
    [SPClient setSharedClient:nil];
}

- (void)setUp
{
    client = [SPClient sharedClient];
}

- (void)tearDown
{
    [SPClient setSharedClient:nil];
}

- (void)testClientInitialization
{
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
    SPClient *directClient = [SPClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx"];
    [directClient getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
        GHAssertNil(error, nil);
        [directClient get:[SPProductType class] identifier:@"6" completion:^(id loadedObject, NSError *error) {
            GHAssertNil(error, nil);
            GHAssertNotNil(loadedObject, nil);
        }];
        [directClient get:[SPResource class] identifier:@"foo" completion:^(id loadedObject, NSError *error) {
            GHAssertNotNil(error, nil);
        }];
    }];
}

- (void)testPlatformSwitch
{
    client = [SPClient clientWithShopId:@"" andApiKey:@"" andSecret:@""];
    
    NSString *currentCountryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    NSArray *naLocales = @[@"US", @"CA"];
    
    if ([naLocales containsObject:currentCountryCode]) {
        GHAssertEqualStrings([SPClient sharedClient].platform, SPPlatformNA, nil);
        GHAssertEqualStrings([SPClient sharedClient].baseURL, @"http://api.spreadshirt.com/api/v1", nil);
    } else {
        GHAssertEqualStrings([SPClient sharedClient].platform, SPPlatformEU, nil);
        GHAssertEqualStrings([SPClient sharedClient].baseURL, @"http://api.spreadshirt.net/api/v1", nil);
    }
}

- (void)testManualPlatformSelection {
    
    SPClient *client1 = [SPClient clientWithShopId:@"" andApiKey:@"" andSecret:@"" andPlatform:SPPlatformEU];
    GHAssertEqualStrings(client1.platform, SPPlatformEU, nil);
    GHAssertEqualStrings(client1.baseURL, @"http://api.spreadshirt.net/api/v1", nil);
    
    SPClient *client2 = [SPClient clientWithShopId:@"" andApiKey:@"" andSecret:@"" andPlatform:SPPlatformNA];
    GHAssertEqualStrings(client2.platform, SPPlatformNA, nil);
    GHAssertEqualStrings(client2.baseURL, @"http://api.spreadshirt.com/api/v1", nil);

    SPClient *client3 = [SPClient clientWithUserId:@"" andApiKey:@"" andSecret:@"" andPlatform:SPPlatformEU];
    GHAssertEqualStrings(client3.platform, SPPlatformEU, nil);
    GHAssertEqualStrings(client3.baseURL, @"http://api.spreadshirt.net/api/v1", nil);

    SPClient* client4 = [SPClient clientWithUserId:@"" andApiKey:@"" andSecret:@"" andPlatform:SPPlatformNA];
    GHAssertEqualStrings(client4.platform, SPPlatformNA, nil);
    GHAssertEqualStrings(client4.baseURL, @"http://api.spreadshirt.com/api/v1", nil);

}

@end
