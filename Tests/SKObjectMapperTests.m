//
//  SetWithPropertiesMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMapper_Private.h>
#import "SpreadKit.h"
#import "SKObjectMapper.h"
#import "SKObjectMappingProvider.h"
#import "SKEntityList.h"
#import "SKBasket.h"

@interface SKObjectMapperTests : GHTestCase
@end

@implementation SKObjectMapperTests

- (void)testUserProductsUrlMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    
    NSData *userData = [NSData dataWithContentsOfFile:filePath];
    NSString* MIMEType = @"application/json";
    
    RKObjectMapping *mapping = [[SKObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SKUser class]];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    
    SKObjectMapper *mapper = [SKObjectMapper mapperWithMIMEType:MIMEType mappingProvider:prov];
    SKUser *user = [[mapper performMappingWithData:userData] objectAtIndex:0];
    
    GHAssertNotNil(user.products.url, @"Products url should be mapped");
}

- (void)testSerialization
{
    
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [serializationMapping mapAttributes:@"token", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:serializationMapping forClass:[SKBasket class]];
    
    SKBasket *basket = [[SKBasket alloc] init];
    basket.token = @"foobar";
    basket.shop = [[SKShop alloc] init];
    
    SKObjectMapper *mapper = [SKObjectMapper mapperWithMIMEType:RKMIMETypeJSON mappingProvider:prov];
    NSString *serialization = [mapper serializeObject:basket];
    GHAssertEqualStrings(serialization, @"{\"token\":\"foobar\"}", @"Basket should have been serialized correctly");
}

- (void)testEmptyObjectSerialization
{
    SKBasket *basket = [[SKBasket alloc] init];
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [serializationMapping mapAttributes:@"token", @"url", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:serializationMapping forClass:[SKBasket class]];
    
    SKObjectMapper *mapper = [SKObjectMapper mapperWithMIMEType:RKMIMETypeJSON mappingProvider:prov];
    NSString *serialization = [mapper serializeObject:basket];
    
    GHAssertNotNil(serialization, @"Empty object should not return empty serialization");
}

@end
