//
//  SPUser.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPList;
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
@property (nonatomic, strong) SPList * products;
@property (nonatomic, strong) SPList * designs;
@property (nonatomic, strong) SPList * productTypes;
@property (nonatomic, strong) SPList * productTypeDepartments;
@property (nonatomic, strong) SPList * printTypes;
@property (nonatomic, strong) SPList * baskets;
@property (nonatomic, strong) SPList * currencies;
@property (nonatomic, strong) SPList * languages;
@property (nonatomic, strong) SPList * countries;
@property (nonatomic, strong) SPList * shops;

@end
