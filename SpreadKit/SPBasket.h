//
//  SPBasket.h
//  SpreadKit
//
//  Created by Sebastian Marr on 10.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPShop.h"

#import "SPEntity.h"

@class SPUser;
@class SPEntityList;

@interface SPBasket : SPEntity

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) SPShop *shop;
@property (nonatomic, strong) SPUser *user;
@property (nonatomic, strong) NSMutableArray *basketItems;
@property (nonatomic, strong) NSArray * links;

@end
