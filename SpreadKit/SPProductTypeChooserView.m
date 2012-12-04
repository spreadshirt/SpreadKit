//
//  SPProductTypeChooserView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 05.09.12.
//
//

#import "SPProductTypeChooserView.h"
#import "SPFullscreenPopup.h"
#import "SPProductType.h"
#import "SPImageLoader.h"
#import "SPClient.h"
#import "SPAppearance.h"

@interface SPProductTypeChooserView ()
{
    SPFullscreenPopup *popup;
    UIButton *button;
}

@end

@implementation SPProductTypeChooserView

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
        [self addSubview:button];
    }
    return self;
}

- (id)initWithProductView:(SPProductView *)productView andDelegate:(id<SPProductTypeChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame]) {
        self.productView = productView;
        self.delegate = delegate;
    }
    return self;
}

+ (SPProductTypeChooserView *)productTypeChooserWithProductView:(SPProductView *)productView andDelegate:(id<SPProductTypeChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    return [[self alloc] initWithProductView:productView andDelegate:delegate andFrame:frame];
}

- (void)setSelectedProductType:(SPProductType *)selectedProductType
{
    _selectedProductType = selectedProductType;
    NSURL * productTypeURL = [[selectedProductType.resources objectAtIndex:0] url];
    [[[SPImageLoader alloc] initWithApiKey:[SPClient sharedClient].apiKey andSecret:[SPClient sharedClient].secret] loadImageFromUrl:productTypeURL withSize:button.frame.size andAppearanceId:selectedProductType.defaultAppearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        [button setImage:image forState:UIControlStateNormal];
    }];
}

- (IBAction)tapped:(id)sender
{
    CGSize popupSize = CGSizeMake(280, 380);
 
    GMGridView *grid = [[GMGridView alloc] initWithFrame:CGRectMake(10,
                                                                   10,
                                                                   popupSize.width - 20,
                                                                   popupSize.height - 20)];
    grid.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    grid.style = GMGridViewStyleSwap;
    grid.itemSpacing = 10;
    grid.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    grid.centerGrid = YES;
    grid.dataSource = self;
    grid.actionDelegate = self;
    
    popup = [[SPFullscreenPopup alloc] initWithSize:popupSize contentView:grid];
    [popup show];
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return _productTypes.count;
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
    
    UIImageView *view = (UIImageView *)cell.contentView;
    view.image = nil;
    SPProductType *type = [self.productTypes objectAtIndex:index];
    
    [[[SPImageLoader alloc] init] loadImageFromUrl:[[type.resources objectAtIndex:0] url] withSize:size  completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        view.image = image;
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
    self.selectedProductType = [_productTypes objectAtIndex:position];
    [self.delegate productTypeChooser:self didSelectProductType:self.selectedProductType];
}

@end