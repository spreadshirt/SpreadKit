//
//  SetWithPropertiesMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <RestKit/RestKit.h>
#import "SpreadKit.h"
#import "SPObjectMapper.h"
#import "SPObjectMappingProvider.h"
#import "SPList.h"
#import "SPBasket.h"

@interface SPObjectMapperTests : GHTestCase
@end

@implementation SPObjectMapperTests

- (void)testUserProductsUrlMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    
    NSData *userData = [NSData dataWithContentsOfFile:filePath];
    NSString* MIMEType = @"application/json";
    
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:MIMEType objectClass:[SPUser class]];
    SPUser *user = [[mapper performMappingWithData:userData] objectAtIndex:0];
    
    GHAssertNotNil(user.products.url, @"Products url should be mapped");
}

- (void)testSerialization
{
    SPBasket *basket = [[SPBasket alloc] init];
    basket.token = @"foobar";
    basket.shop = [[SPShop alloc] init];
    
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:RKMIMETypeJSON objectClass:nil];
    NSString *serialization = [mapper serializeObject:basket];
    GHAssertEqualStrings(serialization, @"{\"token\":\"foobar\",\"basketItems\":[]}", @"Basket should have been serialized correctly");
}

- (void)testEmptyObjectSerialization
{
    SPBasket *basket = [[SPBasket alloc] init];
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [serializationMapping addAttributeMappingsFromArray:@[@"token", @"url"]];
    
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:RKMIMETypeJSON objectClass:nil];
    NSString *serialization = [mapper serializeObject:basket];
    
    GHAssertNotNil(serialization, @"Empty object should not return empty serialization");
}

@end
