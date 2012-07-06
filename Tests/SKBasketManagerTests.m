//
//  SKBasketManagerTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SKBasketManager.h"
#import "SKArticle.h"
#import "SKClient.h"

@interface SKBasketManagerTests : GHAsyncTestCase

@end

@implementation SKBasketManagerTests

- (void)setUpClass
{
    [SKClient clientWithShopId:@"" andApiKey:@"xxx" andSecret:@"xxx"];
}

- (void)testCheckout
{
    SKBasketManager *manager = [[SKBasketManager alloc] init];
    [manager checkoutURLWithCompletion:^(NSURL *checkoutURL, NSError *error) {
        
    }];
}

@end
