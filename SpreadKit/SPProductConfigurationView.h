//
//  SPProductConfigurationView.h
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SPModel.h"
#import "SPImageLoader.h"

@interface SPProductConfigurationView : UIView
@property (readonly) SPProductConfiguration * configuration;
@property (readonly) float viewScale;

- (id) initWithProductConfiguration:(SPProductConfiguration *)theProductConfiguration andFrame:(CGRect)frame;
- (id) initWithImage:(UIImage *) image andFrame:(CGRect) confFrame;
@end
