//
//  SPShop.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPUser;
@class SPList;
@class SPCountry;
@class SPCurrency;
@class SPLanguage;

@interface SPShop : SPEntity

@property (strong) NSURL * url;
@property (strong) NSString * identifier;
@property (strong) NSString * name;
@property (strong) SPUser * user;
@property (strong) SPCountry * country;
@property (strong) SPLanguage * language;
@property (strong) SPCurrency * currency;
@property  BOOL passwordRestricted;
@property  BOOL hidden;
@property (strong) SPList * products;
@property (strong) SPList * designs;
@property (strong) SPList * articles;
@property (strong) SPList * productTypes;
@property (strong) SPList * productTypeDepartments;
@property (strong) SPList * printTypes;
@property (strong) SPList * baskets;
@property (strong) SPList * currencies;
@property (strong) SPList * languages;
@property (strong) SPList * countries;

@end
