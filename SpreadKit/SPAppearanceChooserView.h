//
//  SPAppearanceChooserView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 24.08.12.
//
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>
#import <GMGridView/GMGridViewLayoutStrategies.h>
#import <QuartzCore/QuartzCore.h>

@class SPAppearanceChooserView;
@class SPAppearance;
@class SPProductView;

@protocol SPAppearanceChooserViewDelegate <NSObject>

- (void)appearanceChooser:(SPAppearanceChooserView *)appearanceChooser didSelectAppearance:(SPAppearance *)appearance;

@end

@interface SPAppearanceChooserView : UIView <GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, weak) id<SPAppearanceChooserViewDelegate> delegate;
@property (nonatomic, weak) SPProductView * productView;
@property (nonatomic, weak) SPAppearance * selectedAppearance;
@property (nonatomic)  NSArray * appearances;

- (id)initWithProductView:(SPProductView *)productView andDelegate:(id<SPAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame;
+ (SPAppearanceChooserView *)appearanceChooserWithProductView:(SPProductView *)productView andDelegate:(id<SPAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame;

@end
