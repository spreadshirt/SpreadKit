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
#import "SKAppearanceChooserView.h"
#import "SKProductTypeChooserView.h"

@interface SKProductView : UIView

@property (nonatomic) SKProduct *product;
@property (nonatomic) SKProductType *productType;
@property (readonly) SKView *view;
@property (readonly) float viewScale;

@property (nonatomic, strong) SKAppearanceChooserView * appearanceChooserView;
@property (nonatomic, strong) SKProductTypeChooserView * productTypeChooserView;

- (id)initWithProduct:(SKProduct *)product andFrame:(CGRect)frame;

@end
