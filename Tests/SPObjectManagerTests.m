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
#import "SPList.h"
#import "SPObjectManager.h"
#import "SPBasket.h"

@interface SPObjectManager (Private)

- (void)getSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *, NSError *))completion;
- (void)getList:(SPList *)list completion:(void (^)(SPList *, NSError *))completion;
- (void)getListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion;

@end

@interface SPObjectManagerTests : GHAsyncTestCase
{
    SPObjectManager *manager;
}
@end

@implementation SPObjectManagerTests

- (void)setUp{
    manager = [SPObjectManager objectManagerWithApiKey:@"xxx" andSecret:@"xxx"];
}

- (void)testListLoadingFromUrl
{
    __block NSArray *result;
    
    [self prepare];
    
    [manager getListFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"] withParams:nil completion:^(NSArray *objects, NSError *error) {
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
    RKObjectMapping *productMapping = [[SPObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SPProduct class]];
    __block NSArray *result;
    
    [self prepare];
    
    [manager getSingleEntityFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products/18245494"] withParams:nil intoTargetObject:nil mapping:productMapping completion:^(NSArray *objects, NSError *error) {
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
    user.products = [[SPList alloc] init];
    user.products.url = [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"];
    
    [self prepare];
    
    __block id loadedStuff;
    
    [manager get:user.products completion:^(id loaded, NSError *error) {
        if (error) {
            GHFail(@"Loading should work");
        } else {
            loadedStuff = loaded;
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertTrue([loadedStuff isKindOfClass:[NSArray class]], @"Loading a list should return the loaded elements");
    GHAssertEquals(user.products.elements.count, (unsigned int) 3, @"Loading a list should save the loaded elements");
}

- (void)testListPagination
{
    SPList *list = [[SPList alloc] init];
    list.url = [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/205909/products"];
    
    [self prepare];
    [manager get:list completion:^(id loaded, NSError *error) {
        if (error) {
            GHFail(nil);
        } else {
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(list.elements.count, [list.limit unsignedIntegerValue], @"After the first load, the list should have 'limit' elements");
    
    [self prepare];
    [manager get:list.more completion:^(id loaded, NSError *error) {
        if (error) {
            GHFail(nil);
        } else {
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(list.elements.count, [list.limit unsignedIntegerValue] * 2, @"After loading more, the list should have twice as much elements");
    
    [self prepare];
    [manager get:list.more completion:^(id loaded, NSError *error) {
        if (error) {
            GHFail(nil);
        } else {
            [self notify:kGHUnitWaitStatusSuccess];
        }
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(list.elements.count, [list.limit unsignedIntegerValue] * 3, @"After loading more, the list should have 'limit' more elements");
}

- (void)testPostBasket
{
    SPBasket *basket = [[SPBasket alloc] init];
    //    basket.token = @"test";
    
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
