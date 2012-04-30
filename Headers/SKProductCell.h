//
//  SKProductCell.h
//  SpreadKit
//
//  Created by Sebastian Marr on 02.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKProduct;
@class SKImageLoader;

@interface SKProductCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong, readonly) SKImageLoader *imageLoader;

@property (nonatomic,strong) SKProduct *product;

@end
