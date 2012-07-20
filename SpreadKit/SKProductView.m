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
    rect.origin.y = rect.size.height /4;
    
    rect.size.height /=2;
    float boundaryWidth = rect.size.width;
    rect.size.width = rect.size.height * image.size.width / image.size.height;
    rect.origin.x = rect.origin.x + (boundaryWidth - rect.size.width) / 2;
    [self createImageConfigurationWithImage:image andConfigurationRect: rect];
}
- (void) createImageConfigurationWithImage: (UIImage *) image andConfigurationRect: (CGRect)rect {
    
    rect.size.width *= viewScale;
    rect.size.height *= viewScale;
    rect.origin.x *= viewScale;
    rect.origin.y *= viewScale;
    
    SKProductConfigurationView *configurationView =[[SKProductConfigurationView alloc] initWithImage:image andFrame:rect];
    [self addSubview:configurationView];
}

- (id)initWithProduct:(SKProduct *)theProduct andFrame:(CGRect)frame
{
    if (self = [self initWithProductType:product.productType andFrame:frame]) {
        
        // display product type (default view)
        product = theProduct;
        productConfigurations = product.configurations;

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
            configurationView.layer.zPosition =2;
            [self addSubview:configurationView];
        }
    }
    return self;
}

- (void) loadProductTypeImage {
    NSURL *viewImageURL = [[view.resources objectAtIndex:0] url];
    [[[SKImageLoader alloc] init] loadImageFromUrl:viewImageURL  withSize:self.frame.size andAppearanceId:product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        UIImageView *productTypeView = [[UIImageView alloc] initWithFrame:self.frame];
        productTypeView.image = image;
        productTypeView.contentMode = UIViewContentModeScaleAspectFit;
        productTypeView.layer.zPosition = 1;
        [self addSubview:productTypeView];
    }];
}

@end
