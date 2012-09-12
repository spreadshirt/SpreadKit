//
//  SKProductTypeDeoartmentMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 12.09.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import "SKObjectmappingProvider.h"
#import "SKProductTypeDepartment.h"
#import "SKProductTypeCategory.h"
#import "SKProductType.h"
#import <RestKit/RKObjectMapper_Private.h>

@interface SKProductTypeDepartmentMappingTests : GHTestCase
{
    SKObjectMappingProvider *testable;
}

@end

@implementation SKProductTypeDepartmentMappingTests

-(void)setUpClass
{
    testable = [SKObjectMappingProvider sharedMappingProvider];
}

- (void)testProductTypeDepartmentMapping
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"productTypeDepartment" ofType:@"json"];
    NSError *error = nil;
    NSString *productTypeDepartmentJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString *MIMEType = @"application/json";
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:productTypeDepartmentJSON error:&error];
    
    RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:testable];
    RKObjectMappingResult *result = [mapper performMapping];
    GHAssertNotNil(result, nil);
    
    GHAssertEquals([[result asCollection] count], (NSUInteger)6, nil);
    SKProductTypeDepartment *dept = [[result asCollection] objectAtIndex:0];
    
    // core data
    GHAssertEqualStrings(dept.identifier, @"1", nil);
    GHAssertEqualObjects(dept.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/40000/productTypeDepartments/1"], nil);
    GHAssertEqualObjects(dept.weight, @1.0, nil);
    GHAssertEqualObjects(dept.name, @"Men", nil);
    
    // categories
    GHAssertNotNil(dept.categories, nil);
    GHAssertEquals(dept.categories.count, (NSUInteger)13, nil);
    
    SKProductTypeCategory *cat = [dept.categories objectAtIndex:0];
    GHAssertEqualStrings(cat.name, @"T-Shirts", nil);
    GHAssertEqualStrings(cat.nameSingular, @"T-Shirt", nil);
    GHAssertNotNil(cat.productTypes, nil);
    GHAssertEquals(cat.productTypes.count, (NSUInteger)16, nil);
    SKProductType *type = [cat.productTypes objectAtIndex:0];
    GHAssertEqualObjects(type.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/40000/productTypes/6"], nil);
    GHAssertEqualStrings(type.identifier, @"6", nil);
    GHAssertEqualStrings(cat.identifier, @"24", nil);
}

@end
