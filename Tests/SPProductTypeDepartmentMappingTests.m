//
//  SPProductTypeDeoartmentMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 12.09.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import "SPObjectmappingProvider.h"
#import "SPProductTypeDepartment.h"
#import "SPProductTypeCategory.h"
#import "SPProductType.h"

@interface SPProductTypeDepartmentMappingTests : GHTestCase
{
    SPObjectMappingProvider *testable;
}

@end

@implementation SPProductTypeDepartmentMappingTests

-(void)setUpClass
{
    testable = [SPObjectMappingProvider sharedMappingProvider];
}

- (void)testProductTypeDepartmentMapping
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"productTypeDepartment" ofType:@"json"];
    NSError *error = nil;
    NSString *productTypeDepartmentJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSData *data = [productTypeDepartmentJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    RKObjectMapping *mapping = [testable objectMappingForClass:[SPProductTypeDepartment class]];
    
    NSDictionary *mappingsDictionary = @{ @"": mapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult.firstObject;
    GHAssertNotNil(result, nil);
    
    GHAssertEquals([[result array] count], (NSUInteger)6, nil);
    SPProductTypeDepartment *dept = [[result array] objectAtIndex:0];
    
    // core data
    GHAssertEqualStrings(dept.identifier, @"1", nil);
    GHAssertEqualObjects(dept.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/40000/productTypeDepartments/1"], nil);
    GHAssertEqualObjects(dept.weight, @1.0, nil);
    GHAssertEqualObjects(dept.name, @"Men", nil);
    
    // categories
    GHAssertNotNil(dept.categories, nil);
    GHAssertEquals(dept.categories.count, (NSUInteger)13, nil);
    
    SPProductTypeCategory *cat = [dept.categories objectAtIndex:0];
    GHAssertEqualStrings(cat.name, @"T-Shirts", nil);
    GHAssertEqualStrings(cat.nameSingular, @"T-Shirt", nil);
    GHAssertNotNil(cat.productTypes, nil);
    GHAssertEquals(cat.productTypes.count, (NSUInteger)16, nil);
    SPProductType *type = [cat.productTypes objectAtIndex:0];
    GHAssertEqualObjects(type.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/40000/productTypes/6"], nil);
    GHAssertEqualStrings(type.identifier, @"6", nil);
    GHAssertEqualStrings(cat.identifier, @"24", nil);
}

@end
