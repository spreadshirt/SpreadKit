//
//  SKProductCell.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKProductCell.h"
#import "SKImageLoader.h"
#import "SKProduct.h"
#import "SKResource.h"

@implementation SKProductCell
{
    NSURL *shownImageURL;
}

@synthesize previewImageView;
@synthesize nameLabel;
@synthesize activityIndicator;
@synthesize product;
@synthesize imageLoader;

- (void)prepareForReuse
{
    self.previewImageView.image = nil;
    self.nameLabel = nil;
}

- (void)setProduct:(SKProduct *)theProduct
{
    product = theProduct;
    nameLabel.text = self.product.name;
    
    [self.product.resources enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        SKResource *resource = (SKResource *)obj;
        if ([resource.type isEqualToString:@"preview"]) {
            
            shownImageURL = resource.url;
            
            // determine needed width of preview (retina/non retina)
            CGFloat displayScale = [[UIScreen mainScreen] scale];
            NSNumber *previewImageWidth = [NSNumber numberWithFloat:self.previewImageView.frame.size.width * displayScale];
            
            if (!imageLoader) {
                imageLoader = [[SKImageLoader alloc] init];
            }
            
            // load the image asynchronously
            
            [self.activityIndicator startAnimating];
            
            [imageLoader loadImageFromUrl:resource.url withWidth:previewImageWidth onSuccess:^(UIImage *image, NSURL *imageUrl) {
                // set the image
                resource.image = image;
                // only display the image when it still is correct for the currently displayed product
                if (imageUrl == shownImageURL) {
                    [self.activityIndicator stopAnimating];
                    self.previewImageView.image = image;
                }
            } onFailure:nil];
            *stop = YES;
        }
    }];
}

@end
