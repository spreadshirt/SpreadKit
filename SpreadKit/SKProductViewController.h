//
//  SKProductViewController.h
//  SpreadKit
//
//  Created by Sebastian Marr on 04.09.12.
//
//

#import <UIKit/UIKit.h>
#import "SKAppearanceChooserView.h"
#import "SKProductTypeChooserView.h"
#import "SKProduct.h"

@interface SKProductViewController : UIViewController <SKAppearanceChooserViewDelegate, SKProductTypeChooserViewDelegate>

@property (nonatomic, strong) SKProduct *product;

- (void)productTypeChooserDidSelectProductType:(SKProductType *)productType;

@end
