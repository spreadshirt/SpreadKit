//
//  SKProductCell.h
//  SpreadKit
//
//  Created by Sebastian Marr on 02.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKProduct.h"
#import "SKResource.h"

@interface SKProductCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) SKProduct *product;

- (id)initWithProduct:(SKProduct *)theProduct;

@end
