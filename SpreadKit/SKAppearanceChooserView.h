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

@class SKAppearanceChooserView;
@class SKAppearance;
@class SKProductView;

@protocol SKAppearanceChooserViewDelegate <NSObject>

- (NSArray *)appearanceChooserDidRequestAppearances:(SKAppearanceChooserView *)appearanceChooser;
- (void)appearanceChooser:(SKAppearanceChooserView *)appearanceChooser didSelectAppearance:(SKAppearance *)appearance;

@end

@interface SKAppearanceChooserView : UIView <GMGridViewDataSource>

@property (nonatomic, weak) id<SKAppearanceChooserViewDelegate> delegate;
@property (nonatomic, weak) SKProductView * productView;

- (id)initWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame;
+ (SKAppearanceChooserView *)appearanceChooserWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame;

@end
