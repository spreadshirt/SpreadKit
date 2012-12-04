//
//  ProductCreatorTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 30.07.12.
//
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SPClient.h"
#import "SPProductCreator.h"

@interface SPProductCreatorTests : GHAsyncTestCase

@end

@implementation SPProductCreatorTests

- (void)setUp
{
    [SPClient setSharedClient:[SPClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx"]];
    [self prepare];
    [[SPClient sharedClient] getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)tearDown
{
    [SPClient setSharedClient:nil];
}

- (void)testProductCreation
{
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
