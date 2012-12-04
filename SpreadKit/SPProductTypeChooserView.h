//
//  SPProductTypeChooserView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.09.12.
//
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>

@class SPProductView;
@class SPProductType;
@class SPProductTypeChooserView;

@protocol SPProductTypeChooserViewDelegate <NSObject>

- (void)productTypeChooser:(SPProductTypeChooserView *)productTypeChooser didSelectProductType:(SPProductType *)productType;

@end

@interface SPProductTypeChooserView : UIView <GMGridViewActionDelegate, GMGridViewDataSource>

@property (nonatomic, weak) id<SPProductTypeChooserViewDelegate> delegate;
@property (nonatomic, weak) SPProductView *productView;
@property (nonatomic, weak) SPProductType *selectedProductType;
@property (nonatomic) NSArray *productTypes;

- (id)initWithProductView:(SPProductView *)productView andDelegate:(id<SPProductTypeChooserViewDelegate>)delegate andFrame:(CGRect)frame;
+ (SPProductTypeChooserView *)productTypeChooserWithProductView:(SPProductView *)productView andDelegate:(id<SPProductTypeChooserViewDelegate>)delegate andFrame:(CGRect)frame;

@end
