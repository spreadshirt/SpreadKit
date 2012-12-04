//
//  SPProductView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#import "SPModel.h"
#import "SPAppearanceChooserView.h"
#import "SPProductTypeChooserView.h"

@interface SPProductView : UIView

@property (nonatomic) SPProduct *product;
@property (nonatomic) SPProductType *productType;
@property (readonly) SPView *view;
@property (readonly) float viewScale;

@property (nonatomic, strong) SPAppearanceChooserView * appearanceChooserView;
@property (nonatomic, strong) SPProductTypeChooserView * productTypeChooserView;

- (id)initWithProduct:(SPProduct *)product andFrame:(CGRect)frame;

@end
