//
//  ProductCreatorTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 30.07.12.
//
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <Nocilla/Nocilla.h>

#import "SPConstants.h"
#import "SPClient.h"
#import "SPProductCreator.h"

@interface SPProductCreatorTests : GHAsyncTestCase

@end

@implementation SPProductCreatorTests

- (void)setUpClass
{
    [[LSNocilla sharedInstance] start];
}

- (void)tearDownClass
{
    [[LSNocilla sharedInstance] stop];
}

- (void)setUp
{
    // stubs
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/654135?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation1" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/languages?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation2" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/languages?fullData=true&limit=50&mediaType=json&offset=0").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation2" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/countries?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation3" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/countries?fullData=true&limit=50&mediaType=json&offset=0").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation3" ofType:@"txt"]]);
    
    [SPClient setSharedClient:[SPClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx" andPlatform:SPPlatformEU]];
    [self prepare];
    [[SPClient sharedClient] getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)tearDown
{
    [SPClient setSharedClient:nil];
    [[LSNocilla sharedInstance] clearStubs];
}

- (void)testProductCreation
{
    // stubs
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/654135/productTypes/6?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation4" ofType:@"txt"]]); 
    stubRequest(@"POST", @"http://api.spreadshirt.net/api/v1/shops/654135/designs?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation5" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/654135/designs/u107789065?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testProductCreation6" ofType:@"txt"]]);
    stubRequest(@"PUT", @"http://image.spreadshirt.net/image-server/v1/designs/107789065?").andReturn(200);
    stubRequest(@"POST", @"http://api.spreadshirt.net/api/v1/shops/654135/products?fullData=true&mediaType=json").andReturn(201);
    
    SPProductCreator *creator = [[SPProductCreator alloc] init];
    
    // get a product type
    [self prepare];
    __block SPProductType *type;
    [[SPClient sharedClient] get:[SPProductType class] identifier:@"6" completion:^(id loadedObject, NSError *error) {
        type = (SPProductType *)loadedObject;
        
        GHAssertNil(error, nil);
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    SPProduct *product = [creator createProductWithProductType:type andImage:[UIImage imageNamed:@"testImage.jpg"]];
    
    GHAssertNotNil(product, nil);
    
    [self prepare];
    [creator uploadProduct:product completion:^(SPProduct *uploaded, NSError *error) {
        GHAssertNil(error, nil);
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:60];
    
}

@end
