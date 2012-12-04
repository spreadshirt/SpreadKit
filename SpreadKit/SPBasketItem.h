//
//  SPBasketItem.h
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPShop;
@class SPSize;
@class SPAppearance;
@class SPPrice;

@interface SPBasketItem : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSNumber * quantity;
@property (nonatomic, strong) NSDictionary * element;
@property (nonatomic, strong) NSArray * links;
@property (nonatomic, strong) SPPrice * price;
@property (nonatomic, strong) SPShop * shop;
@property (nonatomic, strong) NSString * origin;

@property (nonatomic, weak) id item;
@property (nonatomic, weak) SPSize * size;
@property (nonatomic, weak) SPAppearance *appearance;

@end
