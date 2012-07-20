//
//  SKProductView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import "SKProductView.h"
#import "SKModel.h"
#import "SKImageLoader.h"

@implementation SKProductView

- (id)initWithProduct:(SKProduct *)product andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // display product type (default view)
        SKProductType *productType = product.productType;
        SKView *defaultView = productType.defaultView;
        
        float viewScale = self.frame.size.width / [defaultView.size.width floatValue];
        
        NSURL *defaultViewImageURL = [[defaultView.resources objectAtIndex:0] url];
        [[[SKImageLoader alloc] init] loadImageFromUrl:defaultViewImageURL  withSize:frame.size andAppearanceId:product.appearance.identifier completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
            UIImageView *productTypeView = [[UIImageView alloc] initWithFrame:self.frame];
            productTypeView.image = image;
            productTypeView.contentMode = UIViewContentModeScaleAspectFit;
            productTypeView.layer.zPosition = 1;
            [self addSubview:productTypeView];
        }];
        
        // put the configurations on the product type
        
        for (SKProductConfiguration *conf in product.configurations) {
            int printAreaIndex = [productType.printAreas indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                if ([[obj identifier] isEqualToString:conf.printArea.identifier]) {
                    return YES;
                } else return NO;
            }];
            SKPrintArea *area = [productType.printAreas objectAtIndex:printAreaIndex];
            
            int viewMapIndex = [defaultView.viewMaps indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                if ([[obj printAreaId] isEqualToString:area.identifier]) {
                    return YES;
                } else return NO;
            }];
            SKViewMap *map = [defaultView.viewMaps objectAtIndex:viewMapIndex];
            float viewMapX = [map.offset.x floatValue] * viewScale;
            float viewMapY = [map.offset.y floatValue] * viewScale;
            
            float designOffsetX = [conf.offset.x floatValue] * viewScale;
            float designOffsetY = [conf.offset.y floatValue] * viewScale;
            float designWidth = [[[[conf.content objectForKey:@"svg"] objectForKey:@"image"] objectForKey:@"width"] floatValue] * viewScale;
            float designHeight = [[[[conf.content objectForKey:@"svg"] objectForKey:@"image"] objectForKey:@"height"] floatValue] * viewScale;
            
            [[[SKImageLoader alloc] init] loadImageFromUrl:[[conf.resources objectAtIndex:0] url] withSize:CGSizeMake(designWidth, designHeight) completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
                CGRect confFrame = CGRectMake(viewMapX + designOffsetX, viewMapY + designOffsetY, designWidth, designWidth);
                UIImageView *designView = [[UIImageView alloc] initWithFrame:confFrame];
                designView.image = image;
                designView.contentMode = UIViewContentModeScaleAspectFit;
                designView.layer.zPosition = 2;
                [self addSubview:designView];
            }];
        }
    }
    return self;
}

@end
