//
//  ProductCreator.m
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import "SPProductCreator.h"
#import "SPClient.h"
#import "SPImageLoader.h"

@implementation SPProductCreator
{
    NSMutableDictionary *productsAndConfigurations;
}

- (id)init
{
    if (self = [super init]) {
        productsAndConfigurations = [NSMutableDictionary dictionary];
    }
    return self;
}

- (SPProduct *) createProductWithProductType: (SPProductType *) productType andImage:(UIImage *) image{
    
    SPProduct *product = [[SPProduct alloc] init];
    product.productType = productType;
    product.appearance = productType.defaultAppearance;
    
    // Create an image configuration with default offset and size
    
    if (image) {
        
        SPProductConfiguration *configuration = [[SPProductConfiguration alloc] init];
        
        configuration.type = @"design";
        configuration.printArea = [productType printAreaForView:productType.defaultView];
        
        
        SPSVGImage *svg = [[SPSVGImage alloc] init];
        configuration.content = svg;
        
        CGRect boundary = configuration.printArea.hardBoundary;
        
        CGFloat imageAspectRatio = image.size.width / image.size.height;
        
        CGFloat width;
        CGFloat height;
        CGFloat x;
        CGFloat y;
        
        // scale the image
        if (image.size.height > image.size.width) {
            height = boundary.size.height / 2;
            width = height * imageAspectRatio;
        } else {
            width = boundary.size.width / 1.3;
            height = width / imageAspectRatio;
        }
        svg.width = [NSNumber numberWithFloat:width];
        svg.height = [NSNumber numberWithFloat:height];
        
        // position the image
        x = boundary.origin.x + (boundary.size.width - width) / 2;
        y = boundary.size.height / 8;
        configuration.offset = [[SPOffset alloc] init];
        configuration.offset.x = [NSNumber numberWithFloat:x];
        configuration.offset.y = [NSNumber numberWithFloat:y];
        
        // link the image for later use
        svg.image = image;
        
        product.configurations = [NSArray arrayWithObject:configuration];
        
    }
    
    return product;
}

-(void)uploadProduct:(SPProduct *)product completion:(void (^)(SPProduct *, NSError *))completion
{
    [productsAndConfigurations setObject:[NSMutableArray array] forKey:[NSNumber numberWithInt:[product hash]]];
    for (SPProductConfiguration *configuration in product.configurations) {
        // check for image configurations
        if ([configuration.content isMemberOfClass:[SPSVGImage class]]) {
            
            UIImage *image = [(SPSVGImage *)[configuration content] image];
            
            // create a and upload a design
            SPDesign *designDraft = [[SPDesign alloc] init];
            [[SPClient sharedClient] post:designDraft completion:^(id loaded, NSError *error) {
                if (error) {
                    completion(nil, error);
                } else {
                    SPDesign *design = (SPDesign *)loaded;
                    [[SPClient sharedClient] get:design completion:^(id loadedObject, NSError *error) {
                        if (error) {
                            completion(nil, error);
                        } else {
                            SPImageLoader *imageLoader = [SPImageLoader loaderWithApiKey:[SPClient sharedClient].apiKey andSecret:[SPClient sharedClient].secret];
                            [imageLoader uploadImage:image forDesign:design completion:^(SPDesign *design, NSError *error) {
                                if (error) {
                                    completion(nil, error);
                                } else {
                                    [(SPSVGImage *)[configuration content] setDesignId:design.identifier];
                                    
                                    // load the design again for available print types
                                    [[SPClient sharedClient] get:design completion:^(id loadedObject, NSError *error) {
                                        if (error) {
                                            completion(nil, error);
                                        } else {
                                            // find allowed print type
                                            configuration.printType = [self printTypeForDesign:loadedObject onProduct:product];
                                            [self configurationUploaded:configuration forProduct:product completion:completion];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)configurationUploaded:(SPProductConfiguration *)conf forProduct:(SPProduct *)product completion:(void (^)(SPProduct *product, NSError *error))completion
{
    NSMutableArray *uploadedConfs = [productsAndConfigurations objectForKey:[NSNumber numberWithInt:[product hash]]];
    [uploadedConfs addObject:conf];
    if (product.configurations.count == uploadedConfs.count) {
        [[SPClient sharedClient] post:product completion:^(id newObject, NSError *error) {
            if (error) {
                completion(nil, error);
            } else {
                completion(product, nil);
            }
        }];
    }
}

- (SPPrintType *)printTypeForDesign:(SPDesign *)design onProduct:(SPProduct *)product
{
    int designPrintTypeIndex = [design.printTypes indexOfObjectPassingTest:^BOOL(id dpt, NSUInteger idx, BOOL *stop) {
        int appearancePrintTypeIndex = [product.appearance.printTypes indexOfObjectPassingTest:^BOOL(id apt, NSUInteger idx, BOOL *stop) {
            return [[apt identifier] isEqualToString:[dpt identifier]];
        }];
        return (appearancePrintTypeIndex != NSNotFound);
    }];
    if (designPrintTypeIndex != NSNotFound) {
        return [design.printTypes objectAtIndex:designPrintTypeIndex];
    } else {
        SPPrintType *defaultPrintType = [[SPPrintType alloc] init];
        defaultPrintType.identifier = @"17";
        return defaultPrintType;
    }
}

@end
