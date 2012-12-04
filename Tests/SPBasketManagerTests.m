//
//  SKBasketManagerTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SPBasketManager.h"
#import "SPArticle.h"
#import "SPClient.h"

@interface SPBasketManagerTests : GHAsyncTestCase

@end

@implementation SPBasketManagerTests

- (void)setUpClass
{
    [SPClient clientWithShopId:@"" andApiKey:@"xxx" andSecret:@"xxx"];
}

- (void)testCheckout
{
}

@end
