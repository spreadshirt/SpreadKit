//
//  SKProductViewController.h
//  SpreadKit
//
//  Created by Sebastian Marr on 04.09.12.
//
//

#import <UIKit/UIKit.h>
#import "SKAppearanceChooserView.h"
#import "SKProduct.h"

@interface SKProductViewController : UIViewController <SKAppearanceChooserViewDelegate>

@property (nonatomic, strong) SKProduct *product;

@end
