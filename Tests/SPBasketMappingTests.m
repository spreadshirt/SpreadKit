//
//  SPBasketMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SPObjectMappingProvider.h"
#import "SPBasket.h"
#import "SPBasketItem.h"
#import "SPArticle.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMapper_Private.h>

@interface SPBasketMappingTests : GHTestCase
{
    SPObjectMappingProvider *testable;
}

@end

@implementation SPBasketMappingTests

- (void)setUpClass
{
    testable = [SPObjectMappingProvider sharedMappingProvider];
}

- (void)testBasketMapping
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"basket" ofType:@"json"];
    NSError *error = nil;
    NSString *basketJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString *MIMEType = @"application/json";
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:basketJSON error:&error];
    
    RKObjectMapping *mapping = [testable objectMappingForClass:[SPBasket class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:testable];
    
    RKObjectMappingResult *result = [mapper mapObject:parsedData atKeyPath:@"" usingMapping:mapping];
    
    SPBasket *basket = (SPBasket *)result;
    GHAssertNotNil(basket, @"basket should have been mapped");
    
    GHAssertEqualStrings(basket.identifier, @"964207d6-af41-43c5-8fd5-64980a959f21", @"basket id should be correct");
    GHAssertEqualObjects(basket.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/baskets/964207d6-af41-43c5-8fd5-64980a959f21"], @"basket url should be correct");
    GHAssertNil(basket.shop, nil);
    GHAssertNil(basket.user, nil);
    GHAssertNotNil(basket.basketItems, @"basket items should exist");
    GHAssertEquals(basket.basketItems.count, (unsigned int) 2, @"correct number of basket items should be mapped");
    
    // test basket item mapping
    SPBasketItem *item = [basket.basketItems objectAtIndex:0];
    
    GHAssertEqualStrings(item.identifier, @"986c53ea-e72e-4dad-8b28-1693b530616b", @"basket item should have the correct identifier");
    GHAssertEqualObjects(item.quantity, [NSNumber numberWithInt:1], @"item should have the right quantity");
    GHAssertEquals(item.links.count, (unsigned int)0, @"item should have no links");
    GHAssertNil(item.shop, nil);
    GHAssertNil(item.origin, nil);
    
    GHAssertEqualStrings([item.element objectForKey:@"type"], @"sprd:article", @"item should have the right type");
    GHAssertEqualStrings([item.element objectForKey:@"href"], @"http://api.spreadshirt.net/api/v1/shops/611779/articles/19275565", nil);
}

- (void)testSerialization
{
    SPBasket *basket = [[SPBasket alloc] init];
    basket.token = @"foobar";
    
    SPBasketItem *item = [[SPBasketItem alloc] init];
    SPArticle *article = [[SPArticle alloc] init];
    article.name = @"test";
    article.url = [NSURL URLWithString:@"http://foo.bar"];
    item.item = article;
    basket.basketItems = [NSMutableArray arrayWithObject:item];
    
    RKObjectMapping *serializationMapping = [testable serializationMappingForClass:[SPBasket class]];
    RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:basket mapping:serializationMapping];
    
    NSError *error = nil;
    
    NSString *serializedString = [serializer serializedObjectForMIMEType:RKMIMETypeJSON error:&error];
    
    GHAssertEqualStrings(serializedString, @"{\"token\":\"foobar\",\"basketItems\":[{\"element\":{\"type\":\"sprd:article\",\"href\":\"http://foo.bar\"}}]}", @"basket with items should serialize correctly");
}
                                      
@end
