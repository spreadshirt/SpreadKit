//
//  ProductCreatorTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 30.07.12.
//
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SKClient.h"
#import "SKProductCreator.h"

@interface SKProductCreatorTests : GHAsyncTestCase

@end

@implementation SKProductCreatorTests

- (void)setUp
{
    [SKClient setSharedClient:[SKClient clientWithShopId:@"654135" andApiKey:@"xxx" andSecret:@"xxx"]];
    [self prepare];
    [[SKClient sharedClient] getShopAndOnCompletion:^(SKShop *shop, NSError *error) {
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void)tearDown
{
    [SKClient setSharedClient:nil];
}

- (void)testProductCreation
{
    SKProductCreator *creator = [[SKProductCreator alloc] init];
    
    // get a product type
    [self prepare];
    __block SKProductType *type;
    [[SKClient sharedClient] get:[SKProductType class] identifier:@"6" completion:^(id loadedObject, NSError *error) {
        type = (SKProductType *)loadedObject;
        GHAssertNil(error, nil);
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    SKProduct *product = [creator createProductWithProductType:type andImage:[UIImage imageNamed:@"testImage.jpg"]];
    
    GHAssertNotNil(product, nil);
    
    [self prepare];
    [creator uploadProduct:product completion:^(SKProduct *uploaded, NSError *error) {
        GHAssertNil(error, nil);
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:60];
    
}

@end
