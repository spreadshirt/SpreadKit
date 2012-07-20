//
//  SKProductView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <UIKit/UIKit.h>

@class SKProduct;

@interface SKProductView : UIView

- (id)initWithProduct:(SKProduct *)product andFrame:(CGRect)frame;

@end
