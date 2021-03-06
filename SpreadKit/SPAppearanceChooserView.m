//
//  SPAppearanceChooserView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.08.12.
//
//

#import "SPAppearanceChooserView.h"
#import "SPClient.h"
#import "SPImageLoader.h"
#import "SPAppearance.h"
#import "UIImage+SpreadKit.h"
#import "SPFullscreenPopup.h"

@interface SPAppearanceChooserView ()
{
    SPFullscreenPopup * popup;
    UIButton *button;
}

@end

@implementation SPAppearanceChooserView

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

- (id)initWithProductView:(SPProductView *)productView andDelegate:(id<SPAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame]) {
        self.productView = productView;
        self.delegate = delegate;
    }
    return self;
}

+ (SPAppearanceChooserView *)appearanceChooserWithProductView:(SPProductView *)productView andDelegate:(id<SPAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    return [[self alloc] initWithProductView:productView andDelegate:delegate andFrame:frame];
}

- (void)setSelectedAppearance:(SPAppearance *)selectedAppearance
{
    _selectedAppearance = selectedAppearance;
    NSURL *appearancePreview = [[selectedAppearance.resources objectAtIndex:0] url];
    [[[SPImageLoader alloc] initWithApiKey:[SPClient sharedClient].apiKey andSecret:[SPClient sharedClient].secret] loadImageFromUrl:appearancePreview withSize:button.frame.size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
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
    
    popup = [[SPFullscreenPopup alloc] initWithSize:popupSize contentView:appearancesGrid];
    
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
    
    SPAppearance *appearance = [self.appearances objectAtIndex:index];
    
    [[[SPImageLoader alloc] init] loadImageFromUrl:[[[appearance resources] objectAtIndex:0] url] withSize:size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
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
