//
//  SKProductConfigurationView.h
//  SpreadKit
//
//  Created by Guido Kämper on 20.07.12.
//  Copyright (c) 2012 Spreadshirt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SKModel.h"
#import "SKImageLoader.h"

@interface SKProductConfigurationView : UIView
@property (readonly) SKProductConfiguration * configuration;
@property (readonly) float viewScale;

- (id) initWithProductConfiguration:(SKProductConfiguration *)theProductConfiguration andFrame:(CGRect)frame;
- (id) initWithImage:(UIImage *) image andFrame:(CGRect) confFrame;
@end
