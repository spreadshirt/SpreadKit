//
//  SKArticle.h
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKShop;
@class SKProduct;
@class SKPrice;

@interface SKArticle : NSObject

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) SKPrice * price;
@property (nonatomic, weak) SKShop * shop;
@property (nonatomic, strong) SKProduct * product;
@property (nonatomic, strong) NSDictionary * articleCategories;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * modified;

@end
