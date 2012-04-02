//
//  SKProductCell.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKProductCell.h"
#import "SKImageLoader.h"

@implementation SKProductCell

@synthesize previewImageView;
@synthesize nameLabel;
@synthesize product;

- (void)setProduct:(SKProduct *)theProduct
{
    product = theProduct;
    nameLabel.text = self.product.name;
    
    [self.product.resources enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        SKResource *resource = (SKResource *)obj;
        if ([resource.type isEqualToString:@"preview"]) {
            NSError *error = nil;
            resource.image = [[[SKImageLoader alloc] init] loadImageFromUrl:resource.url withWidth:[NSNumber numberWithInt:200] error:&error];
            if (error) {
                
            }
            self.previewImageView.image = resource.image;
            *stop = YES;
        }
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
