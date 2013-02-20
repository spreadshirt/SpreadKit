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
    
    RKObjectMapping *mapping = [[SPObjectMappingProvider sharedMappingProvider] objectMappingForClass:[SPUser class]];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:MIMEType mappingProvider:prov];
    SPUser *user = [[mapper performMappingWithData:userData] objectAtIndex:0];
    
    GHAssertNotNil(user.products.url, @"Products url should be mapped");
}

- (void)testSerialization
{
    
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [serializationMapping mapAttributes:@"token", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:serializationMapping forClass:[SPBasket class]];
    
    SPBasket *basket = [[SPBasket alloc] init];
    basket.token = @"foobar";
    basket.shop = [[SPShop alloc] init];
    
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:RKMIMETypeJSON mappingProvider:prov];
    NSString *serialization = [mapper serializeObject:basket];
    GHAssertEqualStrings(serialization, @"{\"token\":\"foobar\"}", @"Basket should have been serialized correctly");
}

- (void)testEmptyObjectSerialization
{
    SPBasket *basket = [[SPBasket alloc] init];
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    [serializationMapping mapAttributes:@"token", @"url", nil];
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setSerializationMapping:serializationMapping forClass:[SPBasket class]];
    
    SPObjectMapper *mapper = [SPObjectMapper mapperWithMIMEType:RKMIMETypeJSON mappingProvider:prov];
    NSString *serialization = [mapper serializeObject:basket];
    
    GHAssertNotNil(serialization, @"Empty object should not return empty serialization");
}

@end
