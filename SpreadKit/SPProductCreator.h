//
//  ProductCreator.h
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPModel.h"

@interface SPProductCreator : NSObject

- (SPProduct *) createProductWithProductType: (SPProductType *) productType andImage:(UIImage *) image;

- (void)uploadProduct:(SPProduct *)product completion:(void (^)(SPProduct *uploaded, NSError *error))completion;

@end
