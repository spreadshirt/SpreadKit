//
//  SPArticle.h
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPShop;
@class SPProduct;
@class SPPrice;

@interface SPArticle : SPEntity

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) SPPrice * price;
@property (nonatomic, weak) SPShop * shop;
@property (nonatomic, strong) SPProduct * product;
@property (nonatomic, strong) NSDictionary * articleCategories;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * modified;

@end
