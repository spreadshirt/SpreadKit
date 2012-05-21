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


@interface SKObjectPosterTests : GHTestCase

@end

@implementation SKObjectPosterTests

- (void)testPostBasket
{
    SKBasket *basket = [[SKBasket alloc] init];
    basket.token = @"test";
    
    SKObjectPoster *poster = [[SKObjectPoster alloc] init];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [mapping mapAttributes:@"token", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:mapping forClass:[SKBasket class]];
    
    GHAssertNil(basket.url, @"");
    
    [poster postObject:basket toURL:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/baskets?mediaType=json"] mappingProvider:prov onSuccess:^(id object) {
        GHAssertNotNil(basket.url, @"Basket should have been created");
        NSLog(@"%@", basket.url);
    } onFailure:^(NSError *error) {
        GHFail(@"No Basket");
    }];
}

@end
