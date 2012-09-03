//
//  SKAppearanceChooserView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.08.12.
//
//

#import "SKAppearanceChooserView.h"
#import "SKClient.h"
#import "SKImageLoader.h"
#import "SKAppearance.h"
#import "UIImage+SpreadKit.h"
#import "SKFullscreenPopup.h"

@interface SKAppearanceChooserView ()
{
    SKFullscreenPopup * popup;
    UIButton *button;
}

@property (nonatomic)  NSArray * appearances;

@end

@implementation SKAppearanceChooserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        button = [[UIButton alloc] initWithFrame:self.bounds];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        button.layer.borderWidth = 2;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = YES;
        [self addSubview:button];
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
}

- (void)setSelectedAppearance:(SKAppearance *)selectedAppearance
{
    _selectedAppearance = selectedAppearance;
    NSURL *appearancePreview = [[selectedAppearance.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] initWithApiKey:[SKClient sharedClient].apiKey andSecret:[SKClient sharedClient].secret] loadImageFromUrl:appearancePreview withSize:button.frame.size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        [button setImage:image forState:UIControlStateNormal];
    }];
}

- (IBAction)tapped:(id)sender {
    
    CGSize popupSize = CGSizeMake(280, 250);
    
    GMGridView *appearancesGrid = [[GMGridView alloc] initWithFrame:CGRectMake(10, 10, popupSize.width - 20, popupSize.height - 20)];
    appearancesGrid.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    appearancesGrid.style = GMGridViewStyleSwap;
    appearancesGrid.itemSpacing = 10;
    appearancesGrid.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    appearancesGrid.centerGrid = YES;
    appearancesGrid.dataSource = self;
    appearancesGrid.actionDelegate = self;
    
    popup = [[SKFullscreenPopup alloc] initWithSize:popupSize contentView:appearancesGrid];
    
    [popup show];
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.appearances.count;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        cell.contentView = imageView;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        cell.layer.borderWidth = 2;
        cell.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    }
    
    UIImageView *preview = (UIImageView *)cell.contentView;
    preview.image = nil;
    
    SKAppearance *appearance = [self.appearances objectAtIndex:index];
    
    [[[SKImageLoader alloc] init] loadImageFromUrl:[[[appearance resources] objectAtIndex:0] url] withSize:size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        preview.image = image;
    }];
    
    return cell;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(44, 44);
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    [popup hide];
    self.selectedAppearance = [self.appearances objectAtIndex:position];
    [self.delegate appearanceChooser:self didSelectAppearance:[self.appearances objectAtIndex:position]];
}

@end
