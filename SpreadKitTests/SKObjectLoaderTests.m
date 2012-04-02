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

@interface SKObjectLoaderTests : GHAsyncTestCase <SKObjectLoaderDelegate>
@end

@implementation SKObjectLoaderTests
{
    NSArray *loadedProducts;
    SKObjectLoader *loader1;
    SKObjectLoader *loader2;
}

- (void)testListLoadingFromUrl
{
    loader1 = [[SKObjectLoader alloc] init];
    loader1.delegate = self;
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SKProduct class]];
    
    [productMapping mapAttributes:@"name", @"weight", @"creator", nil];
    [productMapping mapKeyPath:@"href" toAttribute:@"url"];
    [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    productMapping.rootKeyPath = @"products";

    [self prepare];
    [loader1 loadResourceFromUrl:@"http://api.spreadshirt.net/api/v1/shops/4000/products" mapWith:productMapping];
    [self waitForStatus:GHTestStatusSucceeded timeout:10];
    
    GHAssertEquals([loadedProducts count], (unsigned int) 3, @"All resources should have been loaded");
}

- (void)testSingleResourceLoadingFromUrl
{
    loader2 = [[SKObjectLoader alloc] init];
    loader2.delegate = self;
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SKProduct class]];
    
    [productMapping mapAttributes:@"name", @"weight", @"creator", nil];
    [productMapping mapKeyPath:@"href" toAttribute:@"url"];
    [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    
    [self prepare];
    [loader2 loadResourceFromUrl:@"http://api.spreadshirt.net/api/v1/shops/4000/products/18245494" mapWith:productMapping];
    [self waitForStatus:GHTestStatusSucceeded timeout:10];
    
    GHAssertEquals([loadedProducts count], (unsigned int) 1, @"Single Product should have been loaded");
}

- (void)loader:(id)theLoader didLoadObjects:(NSArray *)theObjects {
    loadedProducts = theObjects;
    if (theLoader == loader1) {
        [self notify:GHTestStatusSucceeded forSelector:@selector(testListLoadingFromUrl)];
    } else if (theLoader == loader2) {
        [self notify:GHTestStatusSucceeded forSelector:@selector(testSingleResourceLoadingFromUrl)];
    }
}

@end
