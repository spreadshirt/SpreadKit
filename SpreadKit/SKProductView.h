//
//  SKProductView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SKModel.h"


@interface SKProductView : UIView 
@property (readonly) SKProduct *product;
@property (readonly) SKProductType *productType;
@property (readonly) NSArray *productConfigurations;
@property (readonly) SKView *view;
@property (readonly) float viewScale;

- (id) initWithProductType: (SKProductType *)theProductType andFrame:(CGRect)frame;
- (id)initWithProduct:(SKProduct *)product andFrame:(CGRect)frame;
- (void) createImageConfigurationWithImage: (UIImage *) image andConfigurationRect: (CGRect)rect;
- (void) createImageConfigurationWithImage: (UIImage *) image;
@end
