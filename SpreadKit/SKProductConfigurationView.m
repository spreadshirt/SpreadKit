//
//  SKProductConfigurationView.m
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import "SKProductConfigurationView.h"

@interface SKProductConfigurationView (Private)
- (void) loadConfigurationImage;
@end

@implementation SKProductConfigurationView
@synthesize configuration, viewScale;

- (id)initWithProductConfiguration:(SKProductConfiguration *)productConfiguration andFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        configuration = productConfiguration;
        [self loadConfigurationImage];
    }
    return self;
}

- (id) initWithImage:(UIImage *) image andFrame:(CGRect) confFrame{
    if (self = [super initWithFrame:confFrame]){
        [self addImage:image];
    }
    return self;
}

- (void) loadConfigurationImage{
    [[[SKImageLoader alloc] init] loadImageFromUrl:[[configuration.resources objectAtIndex:0] url] withSize:self.frame.size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        [self addImage:image];
    }];
}
- (void) addImage: (UIImage *) image {
//    UIView * view = [[UIView alloc] initWithFrame:[self bounds]];
//    view.backgroundColor = [UIColor blueColor];
    UIImageView *designView = [[UIImageView alloc] initWithFrame:[self bounds]];
    designView.image = image;
    designView.contentMode = UIViewContentModeRedraw;
    [self addSubview:designView];
}
@end
