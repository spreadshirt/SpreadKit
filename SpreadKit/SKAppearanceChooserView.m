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

@interface SKAppearanceChooserView ()

@property (nonatomic)  NSArray * appearances;

@property (nonatomic, strong) UIImageView * preview1;
@property (nonatomic, strong) UIImageView * preview2;
@property (nonatomic, strong) UIImageView * preview3;
@property (nonatomic, strong) UIImageView * preview4;
@property (nonatomic, strong) NSArray * previewViews;

@end

@implementation SKAppearanceChooserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *invisibleButton = [[UIButton alloc] initWithFrame:self.bounds];
        [invisibleButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:invisibleButton];
        
        CGFloat miniWidth = self.bounds.size.width / 2;
        CGFloat miniHeight = self.bounds.size.height / 2;
        
        CGFloat x = self.bounds.origin.x;
        CGFloat y = self.bounds.origin.y;
        
        self.preview1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, miniWidth, miniHeight)];
        self.preview2 = [[UIImageView alloc] initWithFrame:CGRectMake(x + miniWidth, y, miniWidth, miniHeight)];
        self.preview3 = [[UIImageView alloc] initWithFrame:CGRectMake(x, y + miniHeight, miniWidth, miniHeight)];
        self.preview4 = [[UIImageView alloc] initWithFrame:CGRectMake(x + miniWidth, y + miniHeight, miniWidth, miniHeight)];
        
        self.previewViews = @[ self.preview1, self.preview2, self.preview3, self.preview4 ];
        
        [invisibleButton addSubview:self.preview1];
        [invisibleButton addSubview:self.preview2];
        [invisibleButton addSubview:self.preview3];
        [invisibleButton addSubview:self.preview4];
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
    
    // display a selection of the appearances on the little thumbnail button
    [appearances enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 4) {
            *stop = YES;
        } else {
            SKAppearance *appearance = (SKAppearance *)obj;
            UIImageView *previewView = [self.previewViews objectAtIndex:idx];
            [[[SKImageLoader alloc] initWithApiKey:[SKClient sharedClient].apiKey andSecret:[SKClient sharedClient].secret] loadImageFromUrl:[[appearance.resources  objectAtIndex:0] url] withSize:previewView.frame.size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
                previewView.image = image;
            }];
        }
    }];
}

- (IBAction)tapped:(id)sender {

    CGFloat appearanceWindowWidth = 280;
    CGFloat appearanceWindowHeight = 375;
    
    // show appearances pop up
    UIView *appearancesPopUp = [[UIView alloc] initWithFrame:self.window.bounds];
    appearancesPopUp.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    appearancesPopUp.alpha = 0;
    
    UIView *appearancesWindow = [[UIView alloc] initWithFrame:CGRectMake(appearancesPopUp.bounds.size.width / 2 - appearanceWindowWidth  / 2, appearancesPopUp.bounds.size.height / 2 - appearanceWindowHeight / 2, appearanceWindowWidth, appearanceWindowHeight)];
    appearancesWindow.backgroundColor = [UIColor whiteColor];
    appearancesWindow.layer.cornerRadius = 5;
    [appearancesPopUp addSubview:appearancesWindow];
    
    UIImage *closeBtnImage = [UIImage spreadKitImageNamed:@"close"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(appearancesWindow.frame.origin.x + appearancesWindow.bounds.size.width - closeBtnImage.size.width / 1.5, appearancesWindow.frame.origin.y - closeBtnImage.size.height / 2.5, closeBtnImage.size.width, closeBtnImage.size.height);
    [closeButton setImage:closeBtnImage forState:UIControlStateNormal];
    closeButton.showsTouchWhenHighlighted = YES;
    [closeButton addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    [appearancesPopUp addSubview:closeButton];
    
    // add appearances grid
    GMGridView *appearancesGrid = [[GMGridView alloc] initWithFrame:CGRectMake(10, 10, appearancesWindow.bounds.size.width - 20, appearancesWindow.bounds.size.height - 20)];
    appearancesGrid.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [appearancesWindow addSubview:appearancesGrid];
    appearancesGrid.style = GMGridViewStyleSwap;
    appearancesGrid.itemSpacing = 10;
    appearancesGrid.minEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    appearancesGrid.centerGrid = YES;
    appearancesGrid.dataSource = self;
    appearancesGrid.actionDelegate = self;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:appearancesPopUp];
    // fade in pop up
    [UIView animateWithDuration:0.3 animations:^{
        appearancesPopUp.alpha = 1;
    }];
}

- (void)closePopup:(id)popup
{
    [UIView animateWithDuration:0.3 animations:^{
        [popup superview].alpha = 0;
    } completion:^(BOOL finished) {
       [[popup superview] removeFromSuperview];
    }];
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
    }
    
    UIImageView *preview = (UIImageView *)cell.contentView;
    preview.image = nil;
    
    [[[SKImageLoader alloc] init] loadImageFromUrl:[[[[self.appearances objectAtIndex:index] resources] objectAtIndex:0] url] withSize:size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
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
    [self closePopup:gridView.superview];
    [self.delegate appearanceChooser:self didSelectAppearance:[self.appearances objectAtIndex:position]];
}

@end
