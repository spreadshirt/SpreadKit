//
//  SKBasketItemMappingTest.m
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SKBasketItem.h"
#import "SKProduct.h"
#import "SKArticle.h"
#import "SKAppearance.h"
#import "SKSize.h"

@interface SKBasketItemMappingTests : GHTestCase

@end


@implementation SKBasketItemMappingTests

- (void)testBasketItemConvenienceMethods
{
    SKBasketItem *testable = [[SKBasketItem alloc] init];
    
    SKArticle *article = [[SKArticle alloc] init];
    article.url = [NSURL URLWithString:@"http://foo.bar/baz"];
    
    GHAssertNil(testable.element, nil);
    
    testable.item = article;
    
    GHAssertNotNil(testable.element, @"element info should have been set");
    GHAssertEqualStrings([testable.element objectForKey:@"href"], article.url.absoluteString, @"element should have the right url");
    GHAssertEqualStrings([testable.element objectForKey:@"type"], @"sprd:article", @"element should have the right type");
    
    SKProduct *product = [[SKProduct alloc] init];
    product.url = [NSURL URLWithString:@"http://baz.bar/foo"];
    
    testable.item = product;
    GHAssertNotNil(testable.element, @"element info should have been set");
    GHAssertEqualStrings([testable.element objectForKey:@"href"], product.url.absoluteString, @"element should have the right url");
    GHAssertEqualStrings([testable.element objectForKey:@"type"], @"sprd:product", @"element should have the right type");
    
    SKAppearance *appearance = [[SKAppearance alloc] init];
    appearance.identifier = @"1";
    
    testable = [[SKBasketItem alloc] init];
    GHAssertNil(testable.element, nil);
    
    testable.appearance = appearance;
    
    NSArray *properties = [testable.element objectForKey:@"properties"];
    
    GHAssertNotNil(testable.element, @"element should have been set");
    GHAssertNotNil(properties, @"properties should have been set");
    GHAssertEquals([properties count], (unsigned int) 1, @"appearance property should have been set");

    BOOL containsAppearance = NO;
    for (NSDictionary *object in properties) {
        if ([[object objectForKey:@"key"] isEqualToString:@"appearance"]) {
            containsAppearance = YES;
            GHAssertEqualStrings([object objectForKey:@"value"], appearance.identifier, @"should contain the right appearance");
        }
    }
    
    GHAssertTrue(containsAppearance, @"properties should contain appearance");

    
    SKSize *size = [[SKSize alloc] init];
    size.identifier = @"2";
    
    testable.size = size;
    properties = [testable.element objectForKey:@"properties"];
    
    GHAssertNotNil(testable.element, @"element should have been set");
    GHAssertNotNil(properties, @"properties should have been set");
    GHAssertEquals([properties count], (unsigned int) 2, @"size property should have been set");
    
    BOOL containsSize = NO;
    for (NSDictionary *object in properties) {
        if ([[object objectForKey:@"key"] isEqualToString:@"size"]) {
            containsSize = YES;
            GHAssertEqualStrings([object objectForKey:@"value"], size.identifier, @"should contain the right appearance");
        }
    }
    GHAssertTrue(containsSize, @"properties should contain size");
}

@end
