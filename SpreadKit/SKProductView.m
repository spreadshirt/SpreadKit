//
//  SKProductView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import "SKProductView.h"
#import "SKProductConfigurationView.h"
#import "SKImageLoader.h"

@interface SKProductView ()

@property UIImageView *productTypeView;
@property UIView *activityIndicatorView;

- (void)loadProductTypeImage;

@end

@implementation SKProductView

- (id)initWithProduct:(SKProduct *)theProduct andFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame]) {
        self.product = theProduct;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.productTypeView = [[UIImageView alloc] init];
    self.productTypeView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.productTypeView];
    
    // appearance chooser
    CGRect appearanceChooserFrame = CGRectMake(5, 5, 44, 44);
    self.appearanceChooserView = [[SKAppearanceChooserView alloc] initWithFrame:appearanceChooserFrame];
    self.appearanceChooserView.productView = self;
    [self addSubview:self.appearanceChooserView];
    
    // product type chooser
    CGRect productTypeChooserFrame = CGRectMake(5, self.bounds.size.height - 44 -5, 44, 44);
    self.productTypeChooserView = [[SKProductTypeChooserView alloc] initWithFrame:productTypeChooserFrame];
    self.productTypeChooserView.productView = self;
    [self addSubview:self.productTypeChooserView];
    
    // activity indicator
    self.activityIndicatorView = [[UIView alloc] initWithFrame:self.bounds];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.activityIndicatorView.layer.zPosition = 10;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin); // center activity indicator
    [self.activityIndicatorView addSubview:activityIndicator];
    activityIndicator.center = self.activityIndicatorView.center;
    self.activityIndicatorView.alpha = 0;
    [self addSubview:self.activityIndicatorView];
}

- (void)setProductType:(SKProductType *)theProductType
{
    _productType = theProductType;
    _view = self.productType.defaultView;
    _viewScale = self.bounds.size.width / [self.view.size.width floatValue];
    
    CGSize scaledPtvSize = CGSizeMake([self.view.size.width floatValue] * self.viewScale, [self.view.size.height floatValue] * self.viewScale);
    CGRect ptvFrame = CGRectMake(0.5f*(CGRectGetWidth(self.bounds)-scaledPtvSize.width), 0.5f*(CGRectGetHeight(self.bounds)-scaledPtvSize.height), scaledPtvSize.width, scaledPtvSize.height);
    
    self.productTypeView.frame = ptvFrame;
    [self loadProductTypeImage];
}

- (void)setProduct:(SKProduct *)theProduct
{
    _product = theProduct;
    self.productType = _product.productType;
    
    for (SKProductConfiguration *conf in _product.configurations) {
        
        SKViewMap *map = [self.view viewMapByPrintAreaId:conf.printArea.identifier];
        
        float viewMapX = [map.offset.x floatValue] * self.viewScale;
        float viewMapY = [map.offset.y floatValue] * self.viewScale;
        
        float designWidth = [[conf size].width floatValue] * self.viewScale;
        float designHeight = [[conf size].height floatValue] * self.viewScale;
        
        float designOffsetX = [conf.offset.x floatValue] * self.viewScale;
        float designOffsetY = [conf.offset.y floatValue] * self.viewScale;
        
        CGRect confFrame = CGRectMake(viewMapX + designOffsetX, viewMapY + designOffsetY, designWidth, designHeight);
        SKProductConfigurationView *configurationView =[[SKProductConfigurationView alloc] initWithProductConfiguration:conf andFrame:confFrame];
        configurationView.layer.zPosition = 1;
        [self.productTypeView addSubview:configurationView];
    }
}

- (void) loadProductTypeImage {
    [self showActivity];
    NSURL *viewImageURL = [[self.view.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] init] loadImageFromUrl:viewImageURL  withSize:self.bounds.size andAppearanceId:self.product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        [self performSelectorOnMainThread:@selector(setProductTypeImage:) withObject:image waitUntilDone:NO];
        [self hideActivity];
    }];
}

- (void)setProductTypeImage:(UIImage *)image {
    self.productTypeView.image = image;
}

- (void)showActivity
{
    [UIView animateWithDuration:0.2 animations:^{
        self.activityIndicatorView.alpha = 1;
    }];
}

- (void)hideActivity
{
    [UIView animateWithDuration:0.2 animations:^{
        self.activityIndicatorView.alpha = 0;
    }];
}

@end
