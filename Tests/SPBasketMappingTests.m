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
    
    NSData *data = [basketJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    
    RKObjectMapping *mapping = [testable objectMappingForClass:[SPBasket class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    NSDictionary *mappingsDictionary = @{ @"": mapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult.firstObject;
    
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
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:serializationMapping objectClass:[SPBasket class] rootKeyPath:nil];
    NSError* error;
    NSDictionary *parameters = [RKObjectParameterization parametersWithObject:basket requestDescriptor:requestDescriptor error:&error];
    
    // Serialize the object to JSON
    NSData *JSON = [RKMIMETypeSerialization dataFromObject:parameters MIMEType:RKMIMETypeJSON error:&error];
    
    NSString *expectedSerialization = @"{\"token\":\"foobar\",\"basketItems\":[{\"element\":{\"type\":\"sprd:article\",\"href\":\"http://foo.bar\"}}]}";
    
    GHAssertTrue([JSON isEqualToData:[expectedSerialization dataUsingEncoding:NSUTF8StringEncoding]], nil);
    
//    GHAssertEqualStrings([[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding], @"{\"token\":\"foobar\",\"basketItems\":[{\"element\":{\"type\":\"sprd:article\",\"href\":\"http://foo.bar\"}}]}", @"basket with items should serialize correctly");
}
                                      
@end
