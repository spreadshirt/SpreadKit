//
//  SKFullscreenPopup.h
//  SpreadKit
//
//  Created by Sebastian Marr on 31.08.12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SKFullscreenPopup : UIView

@property CGSize size;
@property UIView * contentView;

- (id)initWithSize:(CGSize)size contentView:(UIView *)contentView;
- (void)show;
- (void)hide;

@end
