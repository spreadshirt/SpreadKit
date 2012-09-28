//
//  SKUser.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@class SKEntityList;
@class SKCurrency;
@class SKLanguage;
@class SKCountry;

@interface SKUser : SKEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSDate *memberSince;
@property (nonatomic, strong) SKCurrency * currency;
@property (nonatomic, strong) SKCountry * country;
@property (nonatomic, strong) SKLanguage * language;
@property (nonatomic, strong) SKEntityList * products;
@property (nonatomic, strong) SKEntityList * designs;
@property (nonatomic, strong) SKEntityList * productTypes;
@property (nonatomic, strong) SKEntityList * productTypeDepartments;
@property (nonatomic, strong) SKEntityList * printTypes;
@property (nonatomic, strong) SKEntityList * baskets;
@property (nonatomic, strong) SKEntityList * currencies;
@property (nonatomic, strong) SKEntityList * languages;
@property (nonatomic, strong) SKEntityList * countries;
@property (nonatomic, strong) SKEntityList * shops;

@end
