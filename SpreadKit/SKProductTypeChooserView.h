//
//  SKProductTypeChooserView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.09.12.
//
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>

@class SKProductView;
@class SKProductType;
@class SKProductTypeChooserView;

@protocol SKProductTypeChooserViewDelegate <NSObject>

- (void)productTypeChooser:(SKProductTypeChooserView *)productTypeChooser didSelectProductType:(SKProductType *)productType;

@end

@interface SKProductTypeChooserView : UIView <GMGridViewActionDelegate, GMGridViewDataSource>

@property (nonatomic, weak) id<SKProductTypeChooserViewDelegate> delegate;
@property (nonatomic, weak) SKProductView *productView;
@property (nonatomic, weak) SKProductType *selectedProductType;
@property (nonatomic) NSArray *productTypes;

- (id)initWithProductView:(SKProductView *)productView andDelegate:(id<SKProductTypeChooserViewDelegate>)delegate andFrame:(CGRect)frame;
+ (SKProductTypeChooserView *)productTypeChooserWithProductView:(SKProductView *)productView andDelegate:(id<SKProductTypeChooserViewDelegate>)delegate andFrame:(CGRect)frame;

@end
