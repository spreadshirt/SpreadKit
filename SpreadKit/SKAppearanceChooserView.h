//
//  SKAppearanceChooserView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 24.08.12.
//
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>
#import <GMGridView/GMGridViewLayoutStrategies.h>
#import <QuartzCore/QuartzCore.h>

@class SKAppearanceChooserView;
@class SKAppearance;
@class SKProductView;

@protocol SKAppearanceChooserViewDelegate <NSObject>

- (void)appearanceChooser:(SKAppearanceChooserView *)appearanceChooser didSelectAppearance:(SKAppearance *)appearance;

@end

@interface SKAppearanceChooserView : UIView <GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, weak) id<SKAppearanceChooserViewDelegate> delegate;
@property (nonatomic, weak) SKProductView * productView;
@property (nonatomic, weak) SKAppearance * selectedAppearance;
@property (nonatomic)  NSArray * appearances;

- (id)initWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame;
+ (SKAppearanceChooserView *)appearanceChooserWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame;

@end
