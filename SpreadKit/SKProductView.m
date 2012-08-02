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

@interface SKProductView (Private)
- (void) loadProductTypeImage;
- (CGRect) scalePrintareaRectInView: (CGRect) rect;

@end
@implementation SKProductView 
@synthesize productType,product,productConfigurations,view,viewScale;


- (id) initWithProductType: (SKProductType *)theProductType andFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        productType = theProductType;
        view = productType.defaultView;
        viewScale = self.frame.size.width / [view.size.width floatValue];
        [self loadProductTypeImage];
    }
    return self;
}

- (void) createImageConfigurationWithImage: (UIImage *) image{
    SKPrintArea *printarea = [productType printAreaForView: view];
    CGRect rect= [printarea hardBoundary];
    rect.origin.y = rect.size.height /8;
    
    float boundaryWidth = rect.size.width;
    if (image.size.height > image.size.width) {
        rect.size.height /=2;
        rect.size.width = rect.size.height * image.size.width / image.size.height;
    } else {
        rect.size.width /= 1.3;
        rect.size.height = rect.size.width * image.size.height / image.size.width;
    }
    rect.origin.x = rect.origin.x + (boundaryWidth - rect.size.width) / 2;
    [self createImageConfigurationWithImage:image andConfigurationRect: rect];
}

- (void) createImageConfigurationWithImage: (UIImage *) image andConfigurationRect: (CGRect)rect {
    
    rect = [self scalePrintareaRectInView:rect];
    SKProductConfigurationView *configurationView =[[SKProductConfigurationView alloc] initWithImage:image andFrame:rect];
    [self addSubview:configurationView];
}

- (id)initWithProduct:(SKProduct *)theProduct andFrame:(CGRect)frame
{
    product = theProduct;
    productConfigurations = product.configurations;
    
    if (self = [self initWithProductType:product.productType andFrame:frame]) {

        // put the configurations on the product type
        
        for (SKProductConfiguration *conf in productConfigurations) {

            SKViewMap *map = [view viewMapByPrintAreaId:conf.printArea.identifier];
            
            float viewMapX = [map.offset.x floatValue] * viewScale;
            float viewMapY = [map.offset.y floatValue] * viewScale;
            float designWidth = [[conf size].width floatValue] * viewScale;
            float designHeight = [[conf size].height floatValue] * viewScale;
            
            float designOffsetX = [conf.offset.x floatValue] * viewScale;
            float designOffsetY = [conf.offset.y floatValue] * viewScale;
            CGRect confFrame = CGRectMake(viewMapX + designOffsetX, viewMapY + designOffsetY, designWidth, designHeight);
            SKProductConfigurationView *configurationView =[[SKProductConfigurationView alloc] initWithProductConfiguration:conf andFrame:confFrame];
            [self addSubview:configurationView];
        }
    }
    return self;
}

- (void) loadProductTypeImage {
    NSURL *viewImageURL = [[view.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] init] loadImageFromUrl:viewImageURL  withSize:self.frame.size andAppearanceId:product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        UIImageView *productTypeView = [[UIImageView alloc] initWithFrame:self.bounds];

        productTypeView.image = image;
        productTypeView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:productTypeView];
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
