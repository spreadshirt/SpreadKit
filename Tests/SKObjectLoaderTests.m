//
//  SKObjectLoaderTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SKObjectLoader.h"
#import "SKProduct.h"
#import <RestKit/RestKit.h>
#import "SKObjectMappingProvider.h"
#import "SKUser.h"
#import "SKEntityList.h"

@interface SKObjectLoaderTests : GHAsyncTestCase
@end

@implementation SKObjectLoaderTests

- (void)testListLoadingFromUrl
{
    SKObjectLoader *loader1 = [[SKObjectLoader alloc] init];
    __block NSArray *result;
    
    [self prepare];
    
    [loader1 loadEntityListFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"] withParams:nil onSucess:^(NSArray *objects) {
        result = objects;
        [self notify:kGHUnitWaitStatusSuccess];
    } onFailure:^(NSError *error) {
        GHFail(@"Loading should work");
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(result.count, (unsigned int) 3, @"All resources should have been loaded");
}

- (void)testSingleResourceLoadingFromUrl
{
    SKObjectLoader *loader2 = [[SKObjectLoader alloc] init];
    RKObjectMapping *productMapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKProduct class]];
    __block NSArray *result;
    
    [self prepare];
    
    [loader2 loadSingleEntityFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products/18245494"] withParams:nil intoTargetObject:nil mapping:productMapping onSucess:^(NSArray *objects) {
        result = objects;
        [self notify:kGHUnitWaitStatusSuccess];
    } onFailure:^(NSError *error) {
        GHFail(@"Loading should work");
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(result.count, (unsigned int) 1, @"Single Product should have been loaded");
}

- (void)testRelatedListLoading 
{
    SKUser *user = [[SKUser alloc] init];
    user.products = [[SKEntityList alloc] init];
    user.products.url = [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"];
    SKObjectLoader *loader3 = [[SKObjectLoader alloc] init];
    
    [self prepare];
    
    [loader3 load:user.products onSuccess:^(id objects){
        [self notify:kGHUnitWaitStatusSuccess];
    } onFailure:^(NSError *error) {
        GHFail(@"Failure loading products of user");
    }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    
    GHAssertEquals(user.products.elements.count, (unsigned int) 3, @"");
}

@end
