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

- (void)loadProductTypeImage;

@end

@implementation SKProductView

@synthesize productType,product,view,viewScale,productTypeView;

- (id)initWithProductType: (SKProductType *)theProductType andFrame:(CGRect)frame {
    if (self = [self initWithFrame:frame]) {
        self.productType = theProductType;
    }
    return self;
}

- (id)initWithProduct:(SKProduct *)theProduct andFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame]) {
        self.product = theProduct;
    }
    return self;
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
    NSURL *viewImageURL = [[view.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] init] loadImageFromUrl:viewImageURL  withSize:self.frame.size andAppearanceId:product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        
        
        
        self.productTypeView.image = image;
    }];
}

@end
