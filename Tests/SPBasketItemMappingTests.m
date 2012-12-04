//
//  SPBasketItemMappingTest.m
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SPBasketItem.h"
#import "SPProduct.h"
#import "SPArticle.h"
#import "SPAppearance.h"
#import "SPSize.h"

@interface SPBasketItemMappingTests : GHTestCase

@end


@implementation SPBasketItemMappingTests

- (void)testBasketItemConvenienceMethods
{
    SPBasketItem *testable = [[SPBasketItem alloc] init];
    
    SPArticle *article = [[SPArticle alloc] init];
    article.url = [NSURL URLWithString:@"http://foo.bar/baz"];
    
    GHAssertNil(testable.element, nil);
    
    testable.item = article;
    
    GHAssertNotNil(testable.element, @"element info should have been set");
    GHAssertEqualStrings([testable.element objectForKey:@"href"], article.url.absoluteString, @"element should have the right url");
    GHAssertEqualStrings([testable.element objectForKey:@"type"], @"sprd:article", @"element should have the right type");
    
    SPProduct *product = [[SPProduct alloc] init];
    product.url = [NSURL URLWithString:@"http://baz.bar/foo"];
    
    testable.item = product;
    GHAssertNotNil(testable.element, @"element info should have been set");
    GHAssertEqualStrings([testable.element objectForKey:@"href"], product.url.absoluteString, @"element should have the right url");
    GHAssertEqualStrings([testable.element objectForKey:@"type"], @"sprd:product", @"element should have the right type");
    
    SPAppearance *appearance = [[SPAppearance alloc] init];
    appearance.identifier = @"1";
    
    testable = [[SPBasketItem alloc] init];
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

    
    SPSize *size = [[SPSize alloc] init];
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
