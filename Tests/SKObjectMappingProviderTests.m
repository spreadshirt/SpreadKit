//
//  SKClientTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

#import "SpreadKit.h"

@interface RKObjectMapper (Private)

- (id)mapObject:(id)mappableObject atKeyPath:keyPath usingMapping:(id<RKObjectMappingDefinition>)mapping;
- (NSArray*)mapCollection:(NSArray*)mappableObjects atKeyPath:(NSString*)keyPath usingMapping:(id<RKObjectMappingDefinition>)mapping;
- (BOOL)mapFromObject:(id)mappableObject toObject:(id)destinationObject atKeyPath:keyPath usingMapping:(id<RKObjectMappingDefinition>)mapping;
- (id)objectWithMapping:(id<RKObjectMappingDefinition>)objectMapping andData:(id)mappableData;

@end


@interface SKObjectMappingProviderTests : GHTestCase
{
    SKObjectMappingProvider *testable;
}

@end

@implementation SKObjectMappingProviderTests

- (void)setUpClass
{
    testable = [SKObjectMappingProvider sharedMappingProvider];
}

- (void)testMappingInitialization
{
    SKObjectMappingProvider *mappingProvider = [[SKObjectMappingProvider alloc] init];
    GHAssertNotNil(mappingProvider, @"The mapping provider should be initialized");
}

- (void)testSingleProductMapping
{
    // load example json from the file
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];
    
    NSError *error = nil;
    NSString *singleProductJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString *MIMEType = @"application/json";
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:singleProductJSON error:&error];
    
    // load the required mappin explicitly
    RKObjectMapping *mapping = [testable objectMappingForClass:[SKProduct class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:testable];
    
    RKObjectMappingResult* result = [mapper mapObject:parsedData atKeyPath:@"" usingMapping:mapping];
    
    SKProduct *girlieShirt = (SKProduct *)result;
    GHAssertEqualStrings([girlieShirt identifier], @"25386428" ,@"Mapped Product should have the right id");
    GHAssertEqualStrings([girlieShirt name], @"Frauen Girlieshirt" ,@"Mapped Product should have the right name");
    GHAssertEqualStrings([girlieShirt creator], @"confomat6", @"Mapped Product should have the right creator");
    GHAssertEqualObjects([girlieShirt weight], [NSNumber numberWithFloat:2.5386428E7], @"Mapped Product should have the right weight");
    GHAssertEqualStrings([girlieShirt url], @"http://api.spreadshirt.net/api/v1/shops/654135/products/25386428", @"Mapped Product should have the right url");
    
    GHAssertEquals([[girlieShirt resources] count], (unsigned  int) 3, @"There should be the correct number of product resources");
    
    // filter for the preview resource
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type MATCHES 'preview'"];
    
    NSSet *filtered = [[girlieShirt resources] filteredSetUsingPredicate:predicate];
    GHAssertEquals([filtered count], (unsigned int) 1, @"There should be only one preview resource");
    SKResource *preview = [filtered anyObject];
    
    GHAssertEqualStrings([preview url], @"http://image.spreadshirt.net/image-server/v1/products/25386428/views/1", @"Preview resource should have the right url");
}

- (void)testProductListMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"products" ofType:@"json"];
    
    NSError *error = nil;
    NSString *productListJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString* MIMEType = @"application/json";
    
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:productListJSON error:&error];
    
    RKObjectMappingProvider* mappingProvider = testable;
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult* result = [mapper performMapping];
    
    SKProduct *girlieShirt = [[result asCollection] objectAtIndex:0];
    
    GHAssertEqualStrings([girlieShirt identifier], @"25386428" ,@"Mapped Product should have the right id");
    GHAssertEqualStrings([girlieShirt name], @"Frauen Girlieshirt" ,@"Mapped Product should have the right name");
}

- (void)testAlternativeProductListMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"products2" ofType:@"json"];
    
    NSError *error = nil;
    NSString *productListJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString* MIMEType = @"application/json";
    
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:productListJSON error:&error];
    
    RKObjectMappingProvider* mappingProvider = testable;
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult* result = [mapper performMapping];
    
    GHAssertEquals([[result asCollection] count], (unsigned int) 3, @"All resources should be mapped");
}

- (void)testResourceListMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"resources" ofType:@"json"];
    
    NSError *error = nil;
    NSString *productListJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString* MIMEType = @"application/json";
    
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:productListJSON error:&error];
    
    RKObjectMappingProvider* mappingProvider = testable;
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult* result = [mapper performMapping];

    GHAssertNotNil(result, @"A mapping should have ocurred");
    
    GHAssertEquals([[result asCollection] count], (unsigned int) 3, @"All resources should be mapped");
    
    SKResource *resource = [[result asCollection] objectAtIndex:0];
    
    GHAssertEqualStrings([resource mediaType], @"png" ,@"Mapped Product should have the right mediaType");
    GHAssertEqualStrings([resource type], @"preview" ,@"Mapped Product should have the right type");
    GHAssertEqualStrings([resource url], @"http://image.spreadshirt.net/image-server/v1/products/25386428/views/1" ,@"Mapped product should have the right url");
}

@end
