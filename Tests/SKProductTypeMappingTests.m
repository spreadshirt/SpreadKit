//
//  SKProductTypeMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 01.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SKObjectMappingProvider.h"
#import "SKProductType.h"
#import "SKPrice.h"
#import "SKCurrency.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMapper_Private.h>


@interface SKProductTypeMappingTests : GHTestCase
{
    SKObjectMappingProvider *testable;
}

@end


@implementation SKProductTypeMappingTests

- (void)setUpClass
{
    testable = [SKObjectMappingProvider sharedMappingProvider];
}

- (void)testSingleProductTypeMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"productType" ofType:@"json"];
    NSError *error = nil;
    NSString *productTypeJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

    NSString *MIMEType = @"application/json";
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:productTypeJSON error:&error];
    
    RKObjectMapping *mapping = [testable objectMappingForClass:[SKProductType class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:testable];
    
    RKObjectMappingResult* result = [mapper mapObject:parsedData atKeyPath:@"" usingMapping:mapping];
    
    SKProductType *productType = (SKProductType *) result;
    
    GHAssertEqualObjects(productType.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/654135/productTypes/95"], @"ProductType should have the correct url");
    GHAssertEqualStrings(productType.identifier, @"95", @"ProductType should have the right id");
    GHAssertEqualObjects(productType.weight, [NSNumber numberWithFloat:280.0],@"ProductType should have the right weight");
    GHAssertEqualStrings(productType.name, @"Women's Girlie Shirt", @"ProductType should have the right name");
    GHAssertEqualStrings(productType.shortDescription, @"Form-fitting t-shirt for women, 100% cotton, Brand: Continental Clothing", @"Producttype should have the right short description");
    GHAssertEqualStrings(productType.description, @"The t-shirt for girls: feminine and form-fitting with short sleeves. Its round neck is very elastic thanks to its ribbing. Comfort wear as well as its superb ring-spun cotton quality make this t-shirt a light and all-around amenity. Fabric weight 220 g/m², 100% cotton.", @"ProductType should have the right description");
    GHAssertEqualStrings(productType.categoryName, @"T-Shirt", @"product type should have the right category name");
    GHAssertEqualStrings(productType.brand, @"Continental Clothing", @"should have the right brand");
    GHAssertEqualObjects(productType.shippingFactor, [NSNumber numberWithFloat:1.0], @"should have the right shipping factor");
    GHAssertEqualStrings(productType.sizeFitHint, @"slimmer fit", @"should have the right size fit hint");
    GHAssertEqualObjects(productType.price.vatExcluded, [NSNumber numberWithDouble:9.16], @"price should be correct");
    GHAssertEqualObjects(productType.price.currency.identifier, @"1", @"should have the right currency");
    
    GHAssertEqualStrings([[productType.defaultValues objectForKey:@"defaultView"] objectForKey:@"id"], @"1", @"should have the right default view");
    GHAssertEqualStrings([[productType.defaultValues objectForKey:@"defaultAppearance"] objectForKey:@"id"], @"7", @"should have the right default appearance");
    GHAssertEquals(productType.sizes.count, (unsigned int) 4, @"should have the correct amount of sizes");
    
    GHAssertEqualStrings([[productType.sizes objectAtIndex:0] name], @"S", @"Size should have the correct name");
    GHAssertEqualStrings([[productType.sizes objectAtIndex:0] identifier], @"2", @"Size should have the correct id");
    
    GHAssertEquals(productType.appearances.count, (unsigned int) 12, @"should have the right amount of appearances");
    GHAssertEquals(productType.washingInstructions.count, (unsigned int) 6, @"should have the right amount of washing instructions");
    GHAssertEquals(productType.views.count, (unsigned int) 4, @"should have the right amount of views");
    GHAssertEquals(productType.printAreas.count, (unsigned int) 4, @"should have the right amount of print areas");
    GHAssertEquals(productType.stockStates.count, (unsigned int) 48, @"should have the right amount of stock states");
    GHAssertEquals(productType.resources.count, (unsigned int) 3, @"should have the right amount of resources");
}

@end
