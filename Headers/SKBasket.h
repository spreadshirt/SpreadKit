//
//  SKBasket.h
//  SpreadKit
//
//  Created by Sebastian Marr on 10.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKShop.h"
#import "SKUser.h"
#import "SKEntityList.h"

@interface SKBasket : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) SKShop *shop;
@property (nonatomic, strong) SKUser *user;
@property (nonatomic, strong) NSArray *basketItems;

@end
