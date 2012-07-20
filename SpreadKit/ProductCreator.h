//
//  ProductCreator.h
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SKModel.h"

@interface ProductCreator : NSObject
- (SKProduct *) createProductWithProductType: (SKProductType *) productType andImage:(UIImage *) image;
@end
