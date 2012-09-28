//
//  SKBasketItem.h
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@class SKShop;
@class SKSize;
@class SKAppearance;
@class SKPrice;

@interface SKBasketItem : SKEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSNumber * quantity;
@property (nonatomic, strong) NSDictionary * element;
@property (nonatomic, strong) NSArray * links;
@property (nonatomic, strong) SKPrice * price;
@property (nonatomic, strong) SKShop * shop;
@property (nonatomic, strong) NSString * origin;

@property (nonatomic, weak) id item;
@property (nonatomic, weak) SKSize * size;
@property (nonatomic, weak) SKAppearance *appearance;

@end
