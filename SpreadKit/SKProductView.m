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
- (CGRect)scalePrintareaRectInView: (CGRect) rect;

@end

@implementation SKProductView

@synthesize productType,product,view,viewScale,productTypeView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.productTypeView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.productTypeView.contentMode = UIViewContentModeScaleAspectFit;
        self.productTypeView.layer.zPosition = 0;
        [self addSubview:self.productTypeView];
    }
    return self;
}

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
    viewScale = self.frame.size.width / [view.size.width floatValue];
    [self loadProductTypeImage];
}

- (void)setProduct:(SKProduct *)theProduct
{
    product = theProduct;
    
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
        [self addSubview:configurationView];
    }
}

- (void) loadProductTypeImage {
    NSURL *viewImageURL = [[view.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] init] loadImageFromUrl:viewImageURL  withSize:self.frame.size andAppearanceId:product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        self.productTypeView.image = image;
    }];
}

- (CGRect) scalePrintareaRectInView: (CGRect) rect {
    SKPrintArea *printarea = [productType printAreaForView: view];
    SKViewMap *map = [view viewMapByPrintAreaId:printarea.identifier];
    
    float viewMapX = [map.offset.x floatValue] * viewScale;
    float viewMapY = [map.offset.y floatValue] * viewScale;
    CGRect scaledRect = rect;
    scaledRect.size.width *= viewScale;
    scaledRect.size.height *= viewScale;
    scaledRect.origin.x *= viewScale;
    scaledRect.origin.y *= viewScale;
    scaledRect.origin.x += viewMapX ;
    scaledRect.origin.y += viewMapY + (self.bounds.size.height - self.bounds.size.width) /2;
    return scaledRect;
}


@end
