//
//  SPObjectLoaderTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SPProduct.h"
#import <RestKit/RestKit.h>
#import "SPObjectMappingProvider.h"
#import "SPUser.h"
#import "SPEntityList.h"
#import "SPObjectManager.h"
#import "SPBasket.h"

@interface SPObjectManager (Private)

- (void)getSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *, NSError *))completion;
- (void)getEntityList:(SPEntityList *)list completion:(void (^)(SPEntityList *, NSError *))completion;
- (void)getEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion;

@end

@interface SPObjectManagerTests : GHAsyncTestCase
@end

@implementation SPObjectManagerTests

- (void)testListLoadingFromUrl
{
    SPObjectManager *manager1 = [[SPObjectManager alloc] init];
    __block NSArray *result;
    
    [self prepare];
    
    [manager1 getEntityListFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"] withParams:nil completion:^(NSArray *objects, NSError *error) {
        if (error) {
            GHFail(@"Loading should work");
        } else {
            result = objects;
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(result.count, (unsigned int) 3, @"All resources should have been loaded");
}

- (void)testSingleResourceLoadingFromUrl
{
    SPObjectManager *manager2 = [[SPObjectManager alloc] init];
    RKObjectMapping *productMapping = [[SPObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SPProduct class]];
    __block NSArray *result;
    
    [self prepare];
    
    [manager2 getSingleEntityFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products/18245494"] withParams:nil intoTargetObject:nil mapping:productMapping completion:^(NSArray *objects, NSError *error) {
        if (error) {
            GHFail(@"Loading should work");
        } else {
            result = objects;
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(result.count, (unsigned int) 1, @"Single Product should have been loaded");
}

- (void)testRelatedListLoading 
{
    SPUser *user = [[SPUser alloc] init];
    user.products = [[SPEntityList alloc] init];
    user.products.url = [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"];
    SPObjectManager *manager3 = [[SPObjectManager alloc] init];
    
    [self prepare];
    
    [manager3 get:user.products completion:^(id loaded, NSError *error) {
        if (error) {
            GHFail(@"Loading should work");
        } else {
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(user.products.elements.count, (unsigned int) 3, @"");
}

- (void)testPostBasket
{
    SPBasket *basket = [[SPBasket alloc] init];
    //    basket.token = @"test";
    
    SPObjectManager *manager = [SPObjectManager objectManagerWithApiKey:@"xxx" andSecret:@"xxx"];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [mapping mapAttributes:@"token", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:mapping forClass:[SPBasket class]];
    
    [self prepare];
    
    [manager postObject:basket toURL:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/baskets"] completion:^(id object, NSError *error) {
        if (error) {
            GHFail(@"Posting should work");
        } else {
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertNotNil(basket.url, @"Basket should have been created");
}


@end
