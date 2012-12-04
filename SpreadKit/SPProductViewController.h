//
//  SPProductViewController.h
//  SpreadKit
//
//  Created by Sebastian Marr on 04.09.12.
//
//

#import <UIKit/UIKit.h>
#import "SPAppearanceChooserView.h"
#import "SPProductTypeChooserView.h"
#import "SPProduct.h"

@interface SPProductViewController : UIViewController <SPAppearanceChooserViewDelegate, SPProductTypeChooserViewDelegate>

@property (nonatomic, strong) SPProduct *product;

- (void)productTypeChooserDidSelectProductType:(SPProductType *)productType;

@end
