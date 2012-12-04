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
@class SPEntityList;
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
@property (strong) SPEntityList * products;
@property (strong) SPEntityList * designs;
@property (strong) SPEntityList * articles;
@property (strong) SPEntityList * productTypes;
@property (strong) SPEntityList * productTypeDepartments;
@property (strong) SPEntityList * printTypes;
@property (strong) SPEntityList * baskets;
@property (strong) SPEntityList * currencies;
@property (strong) SPEntityList * languages;
@property (strong) SPEntityList * countries;

@end
