//
//  SPArticleMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SPObjectMappingProvider.h"
#import "SPArticle.h"
#import "SPProduct.h"
#import "SPShop.h"
#import "SPPrice.h"
#import "SPCurrency.h"
#import "SPProductType.h"
#import <RestKit/RestKit.h>

@interface SPArticleMappingTests : GHTestCase
{
    SPObjectMappingProvider *testable;
}

@end

@implementation SPArticleMappingTests

- (void)setUpClass
{
    testable = [SPObjectMappingProvider sharedMappingProvider];
}

- (void)testSingleArticleMapping 
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"article" ofType:@"json"];
    NSError *error = nil;
    NSString *articleJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [articleJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    
    
    RKObjectMapping *mapping = [testable objectMappingForClass:[SPArticle class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    NSDictionary *mappingsDictionary = @{ @"": mapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult.firstObject;
    
    SPArticle *article = (SPArticle *) result;
    
    GHAssertEqualStrings(article.name, @"Mehr Sellerie!", @"Article should have the right name");
    GHAssertEqualStrings(article.description, @"", @"Article should have the right description");
    GHAssertNotNil(article.price, @"Article price should have been mapped");
    GHAssertEqualObjects(article.price.vatExcluded, [NSNumber numberWithDouble:19.24], @"Article price should be correct");
    GHAssertEqualObjects(article.price.currency.identifier, @"1", @"Article should have the right currency");
//    GHAssertNotNil(article.shop, @"Article shop should have been mapped");
//    GHAssertEqualObjects(article.shop.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/41985"], @"Article should have the right shop");
    GHAssertEqualObjects(article.product.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/41985/products/26651586"], @"Article should have the correct product");
    GHAssertNotNil(article.resources, @"Article Resources should have been mapped");
    GHAssertEquals(article.resources.count, (NSUInteger)3, @"Article should have the right number of resources");
    
    NSDateComponents *targetCreation = [[NSDateComponents alloc] init];
    targetCreation.day = 22;
    targetCreation.month = 5;
    targetCreation.year = 2012;
    targetCreation.hour = 9;
    targetCreation.minute = 11;
    targetCreation.second = 26;
    targetCreation.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *targetCreationDate = [[NSCalendar currentCalendar] dateFromComponents:targetCreation];
    GHAssertTrue([targetCreationDate isEqualToDate:article.created], @"Article should have the correct creation date");
    
    NSDateComponents *targetModified = [[NSDateComponents alloc] init];
    targetModified.day = 22;
    targetModified.month = 5;
    targetModified.year = 2012;
    targetModified.hour = 9;
    targetModified.minute = 48;
    targetModified.second = 23;
    targetModified.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *targetModifiedDate = [[NSCalendar currentCalendar] dateFromComponents:targetModified];
    GHAssertTrue([targetModifiedDate isEqualToDate:article.modified], @"Article should have the correct creation date");
    
    GHAssertEqualStrings(article.identifier, @"20552749", @"Article should have the correct id");
    GHAssertEqualObjects(article.url, [NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/41985/articles/20552749"], @"Article should have the correct url");
}

@end
