//
//  SPUser.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPEntityList;
@class SPCurrency;
@class SPLanguage;
@class SPCountry;

@interface SPUser : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSDate *memberSince;
@property (nonatomic, strong) SPCurrency * currency;
@property (nonatomic, strong) SPCountry * country;
@property (nonatomic, strong) SPLanguage * language;
@property (nonatomic, strong) SPEntityList * products;
@property (nonatomic, strong) SPEntityList * designs;
@property (nonatomic, strong) SPEntityList * productTypes;
@property (nonatomic, strong) SPEntityList * productTypeDepartments;
@property (nonatomic, strong) SPEntityList * printTypes;
@property (nonatomic, strong) SPEntityList * baskets;
@property (nonatomic, strong) SPEntityList * currencies;
@property (nonatomic, strong) SPEntityList * languages;
@property (nonatomic, strong) SPEntityList * countries;
@property (nonatomic, strong) SPEntityList * shops;

@end
