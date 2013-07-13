//
//  SPProductMappingTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <GHUnitIOS/GHUnit.h>
#import "SPObjectMappingProvider.h"
#import "SPModel.h"

@interface SPProductMappingTests : GHTestCase

@end

@implementation SPProductMappingTests

- (void)testProductSerialization
{
    SPProduct *testProduct = [[SPProduct alloc] init];
    
    SPProductType *productType = [[SPProductType alloc] init];
    productType.identifier = @"productTypeID";
    
    testProduct.productType = productType;
    
    SPAppearance *appearance = [[SPAppearance alloc] init];
    appearance.identifier = @"appearanceID";
    appearance.name = @"appearanceName";
    
    testProduct.appearance = appearance;
    
    
    SPProductConfiguration *conf = [[SPProductConfiguration alloc] init];
    [conf setIdentifier:@"configurationID"];
    
    SPPrintArea *printArea = [[SPPrintArea alloc] init];
    printArea.identifier = @"printAreaID";
    conf.printArea = printArea;
    
    SPPrintType *printType = [[SPPrintType alloc] init];
    printType.identifier = @"printTypeID";
    conf.printType = printType;
    
    SPOffset *offset = [[SPOffset alloc] init];
    [offset setUnit:@"mm"];
    [offset setX:@1.0];
    [offset setY:@2.0];
    [conf setOffset:offset];
    
    SPSVGImage *content = [[SPSVGImage alloc] init];
    content.designId = @"designID";
    content.width = @100;
    content.height = @200;
    conf.content = content;
    
    [testProduct setConfigurations:@[ conf ]];
        
    RKObjectMapping *serializationMapping = [[SPObjectMappingProvider sharedMappingProvider] serializationMappingForClass:[SPProduct class]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:serializationMapping objectClass:[SPBasket class] rootKeyPath:@""];
    NSError* error;
    NSDictionary *parameters = [RKObjectParameterization parametersWithObject:testProduct requestDescriptor:requestDescriptor error:&error];
    
    NSData *JSON = [RKMIMETypeSerialization dataFromObject:parameters MIMEType:RKMIMETypeJSON error:&error];
    
    GHAssertEqualStrings([NSString stringWithUTF8String:[JSON bytes]], @"{\"appearance\":{\"id\":\"appearanceID\"},\"configurations\":[{\"printArea\":{\"id\":\"printAreaID\"},\"id\":\"configurationID\",\"content\":{\"svg\":{\"image\":{\"width\":100,\"designId\":\"designID\",\"height\":200}}},\"offset\":{\"unit\":\"mm\",\"x\":1,\"y\":2},\"printType\":{\"id\":\"printTypeID\"}}],\"productType\":{\"id\":\"productTypeID\"}}", nil);
    
}

@end
