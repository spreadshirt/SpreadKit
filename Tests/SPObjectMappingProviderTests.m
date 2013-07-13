//
//  SPClientTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <RestKit/RestKit.h>
#import "SpreadKit.h"


@interface SPObjectMappingProviderTests : GHTestCase
{
    SPObjectMappingProvider *testable;
}

@end

@implementation SPObjectMappingProviderTests

- (void)setUpClass
{
    testable = [SPObjectMappingProvider sharedMappingProvider];
}

- (void)testMappingInitialization
{
    SPObjectMappingProvider *mappingProvider = [[SPObjectMappingProvider alloc] init];
    GHAssertNotNil(mappingProvider, @"The mapping provider should be initialized");
}

- (void)testSingleProductMapping
{
    // load example json from the file
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];
    
    NSString *singleProductJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [singleProductJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    
    // load the required mapping explicitly
    RKObjectMapping *mapping = [testable objectMappingForClass:[SPProduct class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    
    NSDictionary *mappingsDictionary = @{ @"": mapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult.firstObject;
    
    SPProduct *girlieShirt = (SPProduct *)result;
    GHAssertEqualStrings([girlieShirt identifier], @"25386428" ,@"Mapped Product should have the right id");
    GHAssertEqualStrings([girlieShirt name], @"Frauen Girlieshirt" ,@"Mapped Product should have the right name");
    GHAssertEqualStrings([girlieShirt creator], @"confomat6", @"Mapped Product should have the right creator");
    GHAssertEqualObjects([girlieShirt weight], [NSNumber numberWithFloat:2.5386428E7], @"Mapped Product should have the right weight");
    GHAssertEqualObjects([girlieShirt url], [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/654135/products/25386428"], @"Mapped Product should have the right url");
    
    GHAssertEquals([[girlieShirt resources] count], (unsigned  int) 3, @"There should be the correct number of product resources");
    
    GHAssertNotNil([girlieShirt restrictions], @"Product restrictions should have been mapped");
    
    GHAssertEquals([girlieShirt freeColorSelection], YES, @"Product color selection should have been mapped");
    
    GHAssertNotNil(girlieShirt.productType, @"Product Type should have been mapped");
    
    GHAssertEqualObjects(girlieShirt.productType.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/654135/productTypes/95"], @"Product Type shpuld have the right url");
    
    // filter for the preview resource
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type MATCHES 'preview'"];

    NSArray *filtered = [[girlieShirt resources] filteredArrayUsingPredicate:predicate];
    GHAssertEquals([filtered count], (unsigned int) 1, @"There should be only one preview resource");
    SPResource *preview = [filtered objectAtIndex:0];
    
    GHAssertEqualObjects([preview url], [NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/products/25386428/views/1"], @"Preview resource should have the right url");
}

- (void)testProductListMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"products" ofType:@"json"];
    
    NSError *error = nil;
    NSString *productListJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [productListJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    
    SPObjectMappingProvider* mappingProvider = testable;

    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingProvider.mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult.firstObject;
    

    SPProduct *girlieShirt = (SPProduct *)result;
    
    GHAssertEqualStrings([girlieShirt identifier], @"25386428" ,@"Mapped Product should have the right id");
    GHAssertEqualStrings([girlieShirt name], @"Frauen Girlieshirt" ,@"Mapped Product should have the right name");
}

- (void)testAlternativeProductListMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"products2" ofType:@"json"];
    
    NSError *error = nil;
    NSString *productListJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [productListJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    
    SPObjectMappingProvider* mappingProvider = testable;
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingProvider.mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult;
    
    GHAssertEquals([[result array] count], (unsigned int) 3, @"All resources should be mapped");
}

@end
