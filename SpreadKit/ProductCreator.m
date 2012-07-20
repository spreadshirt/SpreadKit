//
//  ProductCreator.m
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import "ProductCreator.h"

@implementation ProductCreator
- (SKProduct *) createProductWithProductType: (SKProductType *) productType andImage:(UIImage *) image{
    SKProduct *product = [[SKProduct alloc] init];
    [product setProductType:productType];
    //[product setAppearance:[productType defaultAppearance];
     
    NSMutableArray *configurations = [NSMutableArray array];
    SKProductConfiguration *configuration = [[SKProductConfiguration alloc] init];
     
     
    [product setConfigurations:configurations];
    return product;
}
@end
