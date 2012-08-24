//
//  SKAppearanceChooserView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.08.12.
//
//

#import "SKAppearanceChooserView.h"

@interface SKAppearanceChooserView ()

@property (nonatomic)  NSArray * appearances;

@end

@implementation SKAppearanceChooserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame]) {
        self.productView = productView;
        self.delegate = delegate;
    }
    return self;
}

+ (SKAppearanceChooserView *)appearanceChooserWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    return [[self alloc] initWithProductView:productView andDelegate:delegate andFrame:frame];
}

- (void)setDelegate:(id<SKAppearanceChooserViewDelegate>)delegate
{
    _delegate = delegate;
    
    // ask the delegate for appearances to display
    self.appearances = [NSArray arrayWithArray:[delegate appearanceChooserDidRequestAppearances:self]];
}

- (void)setAppearances:(NSArray *)appearances
{
    _appearances = appearances;
    
    // display the appearances
}

@end
