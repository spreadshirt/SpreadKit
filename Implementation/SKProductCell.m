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
@synthesize activityIndicator;
@synthesize product;

- (void)setProduct:(SKProduct *)theProduct
{
    product = theProduct;
    nameLabel.text = self.product.name;
    
    [self.product.resources enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        SKResource *resource = (SKResource *)obj;
        if ([resource.type isEqualToString:@"preview"]) {
            // load image
            [self.activityIndicator startAnimating];
            
            // determine needed width of preview (retina/non retina)
            CGFloat displayScale = [[UIScreen mainScreen] scale];
            NSNumber *previewImageWidth = [NSNumber numberWithFloat:self.previewImageView.frame.size.width * displayScale];
            
            [[[SKImageLoader alloc] init] loadImageFromUrl:resource.url withWidth:previewImageWidth onSuccess:^(UIImage *image) {
                // set the image and show it
                [self.activityIndicator stopAnimating];
                resource.image = image;
                self.previewImageView.image = resource.image;
            } onFailure:^ (NSError *error) {
                // do some error handling
            }];
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
