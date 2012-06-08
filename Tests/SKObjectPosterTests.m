//
//  SKObjectPosterTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 11.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <RestKit/RestKit.h>

#import "SKBasket.h"
#import "SKObjectPoster.h"


@interface SKObjectPosterTests : GHAsyncTestCase

@end

@implementation SKObjectPosterTests

- (void)testPostBasket
{
    SKBasket *basket = [[SKBasket alloc] init];
//    basket.token = @"test";
    
    SKObjectPoster *poster = [[SKObjectPoster alloc] init];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [mapping mapAttributes:@"token", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:mapping forClass:[SKBasket class]];
    
    [self prepare];
    
    [poster postObject:basket toURL:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/baskets?mediaType=json"] apiKey:@"xxx" secret:@"xxx" mappingProvider:prov completion:^(id object, NSError *error) {
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
