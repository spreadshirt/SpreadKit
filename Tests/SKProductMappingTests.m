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
    
    SKProductType *productType = [[SKProductType alloc] init];
    productType.identifier = @"productTypeID";
    
    testProduct.productType = productType;
    
    SKAppearance *appearance = [[SKAppearance alloc] init];
    appearance.identifier = @"appearanceID";
    appearance.name = @"appearanceName";
    
    testProduct.appearance = appearance;
    
    
    SKProductConfiguration *conf = [[SKProductConfiguration alloc] init];
    [conf setIdentifier:@"configurationID"];
    
    SKPrintArea *printArea = [[SKPrintArea alloc] init];
    printArea.identifier = @"printAreaID";
    conf.printArea = printArea;
    
    SKPrintType *printType = [[SKPrintType alloc] init];
    printType.identifier = @"printTypeID";
    conf.printType = printType;
    
    SKOffset *offset = [[SKOffset alloc] init];
    [offset setUnit:@"mm"];
    [offset setX:@1.0];
    [offset setY:@2.0];
    [conf setOffset:offset];
    
    SKSVGImage *content = [[SKSVGImage alloc] init];
    content.designId = @"designID";
    content.width = @100;
    content.height = @200;
    conf.content = content;
    
    [testProduct setConfigurations:@[ conf ]];
        
    RKObjectMapping *serializationMapping = [[SKObjectMappingProvider sharedMappingProvider] serializationMappingForClass:[SKProduct class]];
    RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:testProduct mapping:serializationMapping];
    
    NSError *error = nil;
    
    NSString *serialized = [serializer serializedObjectForMIMEType:RKMIMETypeJSON error:&error];
    
    GHAssertEqualStrings(serialized, @"{\"appearance\":{\"id\":\"appearanceID\"},\"configurations\":[{\"printArea\":{\"id\":\"printAreaID\"},\"id\":\"configurationID\",\"content\":{\"svg\":{\"image\":{\"width\":100,\"designId\":\"designID\",\"height\":200}}},\"offset\":{\"unit\":\"mm\",\"x\":1,\"y\":2},\"printType\":{\"id\":\"printTypeID\"}}],\"productType\":{\"id\":\"productTypeID\"}}", nil);
    
}

@end
