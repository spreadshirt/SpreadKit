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

@interface SKObjectLoaderTests : GHTestCase
@end

@implementation SKObjectLoaderTests
{
    SKObjectLoader *loader1;
    SKObjectLoader *loader2;
}

- (void)testListLoadingFromUrl
{
    loader1 = [[SKObjectLoader alloc] init];
        
    [loader1 loadEntityListFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"] onSucess:^(NSArray *objects) {
        GHAssertEquals(objects.count, (unsigned int) 3, @"All resources should have been loaded");

    } onFailure:^(NSError *error) {
        GHFail(@"Loading should work");
    }];
}

- (void)testSingleResourceLoadingFromUrl
{
    loader2 = [[SKObjectLoader alloc] init];
    
    RKObjectMapping *productMapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKProduct class]];
    
    [loader2 loadSingleEntityFromUrl:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products/18245494"] mapping:productMapping onSucess:^(NSArray *objects) {
        GHAssertEquals(objects.count, (unsigned int) 1, @"Single Product should have been loaded");
    } onFailure:^(NSError *error) {
        GHFail(@"Loading should work");
    }];
}

- (void)testRelatedListLoading 
{
    SKUser *user = [[SKUser alloc] init];
    user.products = [[SKEntityList alloc] init];
    user.products.url = [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/4000/products"];
    SKObjectLoader *loader3 = [[SKObjectLoader alloc] init];
    [loader3 load:user.products onSuccess:^(id objects){
        GHAssertEquals(user.products.elements.count, (unsigned int) 3, @"");
        return;
    } onFailure:^(NSError *error) {
        GHFail(@"Failure loading products of user");
    }];
}

@end
