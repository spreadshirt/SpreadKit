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
    
    SKObjectMapper *mapper = [SKObjectMapper mapperWithMIMEType:MIMEType data:userData mappingProvider:prov];
    SKUser *user = [[mapper performMapping] objectAtIndex:0];
    
    GHAssertNotNil(user.products.url, @"Products url should be mapped");
}

@end
