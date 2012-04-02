//
//  SKProductCell.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKProductCell.h"

@implementation SKProductCell

@synthesize previewImageView;
@synthesize nameLabel;
@synthesize product;

- (void)setProduct:(SKProduct *)theProduct
{
    product = theProduct;
    nameLabel.text = self.product.name;
    
    [self.product.resources enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        previewImageView.image = [(SKResource *)obj image];
        *stop = YES;
    }];
}

- (id)initWithProduct:(SKProduct *)theProduct
{
    if (self = [super init]) {
        self.product = theProduct;
    }
    return self;
}

@end
