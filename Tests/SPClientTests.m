//
//  SPClientTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <Nocilla/Nocilla.h>

#import "SpreadKit.h"

@interface SPClientTests : GHAsyncTestCase
{
    SPClient *client;
}
@end

@implementation SPClientTests

- (void)setUpClass
{
    [[LSNocilla sharedInstance] start];
    [SPClient setSharedClient:nil];
}

- (void)setUp
{
    client = [SPClient sharedClient];
}

- (void)tearDown
{
    [[LSNocilla sharedInstance] clearStubs];
    [SPClient setSharedClient:nil];
}

- (void)tearDownClass
{
    [[LSNocilla sharedInstance] stop];
}

- (void)testClientInitialization
{
    GHAssertNil(client, @"Shared client should be nil at the beginning");
    
    // initialize the shared client
    
    client = [SPClient clientWithShopId:@"foo"
                              andApiKey:@"bar" 
                              andSecret:@"baz"
                            andPlatform:SPPlatformEU];
    
    GHAssertNotNil(client, @"Local client should be initialized");
    GHAssertNotNil(client, @"Shared client should have been set");
    GHAssertEqualObjects(client, [SPClient sharedClient], @"Shared client should be the newly initialized client");
    
    GHAssertEqualStrings(client.apiKey, @"bar", @"Client should have the right API key");
    GHAssertEqualStrings(client.secret, @"baz", @"Client should have the right secret");
    GHAssertNil(client.userId, @"Client should have the right no user ID");
    GHAssertEqualStrings(client.shopId, @"foo", @"Client should have the right shop ID");
    
    // initialize another client
    client = [SPClient clientWithUserId:@"" andApiKey:@"" andSecret:@"" andPlatform:SPPlatformEU];
    GHAssertNotEqualObjects(client, [SPClient sharedClient], @"Shared client should not have been overriden by new instance");
}

- (void)testDirectIdLoading
{
    SPClient *directClient = [SPClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx" andPlatform:SPPlatformEU];
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

- (void)testProductDeletion
{
    // stubs
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/654135?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion1" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/languages?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion2" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/languages?fullData=true&limit=50&mediaType=json&offset=0").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion2" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/countries?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion3" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/countries?fullData=true&limit=50&mediaType=json&offset=0").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion3" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/654135/productTypes/6?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion4" ofType:@"txt"]]);
    stubRequest(@"POST", @"http://api.spreadshirt.net/api/v1/shops/654135/designs?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion5" ofType:@"txt"]]);
    stubRequest(@"DELETE", @"http://api.spreadshirt.net/api/v1/shops/654135/designs/u107788119?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion6" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/654135/designs/u107788119?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductDeletion7" ofType:@"txt"]]);
    
    SPClient *thisClient = [SPClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx" andPlatform:SPPlatformEU];
    
    SPDesign *design = [[SPDesign alloc] init];
    design.description = @"Test Design";
    
    [self prepare];
    
    [thisClient getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
        [thisClient post:design completion:^(id newObject, NSError *error) {
            
            if (error) {
                GHFail(@"Something went wrong posting the design");
            }
            
            [thisClient delete:design completion:^(NSError *error) {
                if (error) {
                    GHFail(@"Something went wrong deleting the design");
                }
                [self notify:kGHUnitWaitStatusSuccess];
            }];
        }];
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    [self prepare];
    
    __block NSError *deleteError;
    [thisClient get:design completion:^(id loadedObject, NSError *error) {
        if (!error) {
            GHFail(@"Design should have been deleted!");
        }
        deleteError = error;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(deleteError, nil);
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
