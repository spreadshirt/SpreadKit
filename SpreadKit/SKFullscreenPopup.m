//
//  SKFullscreenPopup.m
//  SpreadKit
//
//  Created by Sebastian Marr on 31.08.12.
//
//

#import "SKFullscreenPopup.h"

#import "UIImage+SpreadKit.h"

@interface SKFullscreenPopup ()
{
    UIView * fullScreenView;
    UIWindow * keyWindow;
}

@end

@implementation SKFullscreenPopup

- (id)initWithSize:(CGSize)size contentView:(UIView *)contentView
{
    if (self = [super init]) {
        self.size = size;
        self.contentView = contentView;
    }
    return self;
}

- (void)show
{
    keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    // semi transparent background
    fullScreenView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    fullScreenView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    // popup window
    CGRect windowFrame = CGRectMake((fullScreenView.bounds.size.width - self.size.width) / 2,
                                    (fullScreenView.bounds.size.height - self.size.height) / 2,
                                    self.size.width,
                                    self.size.height);
    UIView *window = [[UIView alloc] initWithFrame:windowFrame];
    window.backgroundColor = [UIColor whiteColor];
    window.layer.cornerRadius = 5;
    
    [window addSubview:self.contentView];
    self.contentView.clipsToBounds = YES;
    
    UIImage *closeButtonImage = [UIImage spreadKitImageNamed:@"close"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(window.frame.origin.x + window.frame.size.width - closeButtonImage.size.width / 1.5,
                                   window.frame.origin.y - closeButtonImage.size.height / 2.5,
                                   closeButtonImage.size.width,
                                   closeButtonImage.size.height);
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    closeButton.showsTouchWhenHighlighted = YES;
    [closeButton addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    
    [fullScreenView addSubview:window];
    [fullScreenView addSubview:closeButton];
    
    fullScreenView.alpha = 0;
    [keyWindow addSubview:fullScreenView];
    [UIView animateWithDuration:0.3 animations:^{
        fullScreenView.alpha = 1;
    }];
}

- (void)hide
{
    [self closePopup:self];
}

- (void)closePopup:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        fullScreenView.alpha = 0;
    } completion:^(BOOL finished) {
        [fullScreenView removeFromSuperview];
    }];
}

@end
