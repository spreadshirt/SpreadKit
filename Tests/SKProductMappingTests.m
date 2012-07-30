//
//  SKProductMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <GHUnitIOS/GHUnit.h>
#import "SKobjectMappingProvider.h"
#import "SKModel.h"

@interface SKProductMappingTests : GHTestCase

@end

@implementation SKProductMappingTests

- (void)testProductSerialization
{
    SKProduct *testProduct = [[SKProduct alloc] init];
    SKProductConfiguration *conf = [[SKProductConfiguration alloc] init];
    [conf setIdentifier:@"foo"];
    SKOffset *offset = [[SKOffset alloc] init];
    [offset setUnit:@"mm"];
    [offset setX:@1.0];
    [offset setY:@2.0];
    [conf setOffset:offset];
    [testProduct setConfigurations:@[ conf ]];
    
    conf.content = [[SKSVGImage alloc] init];
    
    RKObjectMapping *serializationMapping = [[SKObjectMappingProvider sharedMappingProvider] serializationMappingForClass:[SKProduct class]];
    RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:testProduct mapping:serializationMapping];
    
    NSError *error = nil;
    
    NSString *serialized = [serializer serializedObjectForMIMEType:RKMIMETypeJSON error:&error];
    
}

@end
