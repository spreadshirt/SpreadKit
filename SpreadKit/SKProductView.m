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

@synthesize productType,product,view,viewScale,productTypeView;

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
    // appearance chooser
    CGRect appearanceChooserFrame = CGRectMake(5, 5, 44, 44);
    self.appearanceChooserView = [[SKAppearanceChooserView alloc] initWithFrame:appearanceChooserFrame];
    self.appearanceChooserView.productView = self;
    [self addSubview:self.appearanceChooserView];
    
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
    productType = theProductType;
    view = productType.defaultView;
    viewScale = self.bounds.size.width / [view.size.width floatValue];
    
    CGSize scaledPtvSize = CGSizeMake([view.size.width floatValue] * viewScale, [view.size.height floatValue] * viewScale);
    CGRect ptvFrame = CGRectMake(0.5f*(CGRectGetWidth(self.bounds)-scaledPtvSize.width), 0.5f*(CGRectGetHeight(self.bounds)-scaledPtvSize.height), scaledPtvSize.width, scaledPtvSize.height);
    
    [productTypeView removeFromSuperview];
    
    productTypeView = [[UIImageView alloc] initWithFrame:ptvFrame];
    productTypeView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:productTypeView];
    
    [self loadProductTypeImage];
}

- (void)setProduct:(SKProduct *)theProduct
{
    product = theProduct;
    self.productType = product.productType;
    self.appearanceChooserView.selectedAppearance = product.appearance;
    
    for (SKProductConfiguration *conf in product.configurations) {
        
        SKViewMap *map = [view viewMapByPrintAreaId:conf.printArea.identifier];
        
        float viewMapX = [map.offset.x floatValue] * viewScale;
        float viewMapY = [map.offset.y floatValue] * viewScale;
        
        float designWidth = [[conf size].width floatValue] * viewScale;
        float designHeight = [[conf size].height floatValue] * viewScale;
        
        float designOffsetX = [conf.offset.x floatValue] * viewScale;
        float designOffsetY = [conf.offset.y floatValue] * viewScale;
        
        CGRect confFrame = CGRectMake(viewMapX + designOffsetX, viewMapY + designOffsetY, designWidth, designHeight);
        SKProductConfigurationView *configurationView =[[SKProductConfigurationView alloc] initWithProductConfiguration:conf andFrame:confFrame];
        configurationView.layer.zPosition = 1;
        [productTypeView addSubview:configurationView];
    }
}

- (void) loadProductTypeImage {
    [self showActivity];
    NSURL *viewImageURL = [[view.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] init] loadImageFromUrl:viewImageURL  withSize:self.frame.size andAppearanceId:product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        self.productTypeView.image = image;
        [self hideActivity];
    }];
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
