//
//  SKShop.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKUser;
@class SKEntityList;
@class SKCountry;
@class SKCurrency;
@class SKLanguage;

@interface SKShop : NSObject

@property (strong) NSURL * url;
@property (strong) NSString * identifier;
@property (strong) NSString * name;
@property (strong) SKUser * user;
@property (strong) SKCountry * country;
@property (strong) SKLanguage * language;
@property (strong) SKCurrency * currency;
@property  BOOL passwordRestricted;
@property  BOOL hidden;
@property (strong) SKEntityList * products;
@property (strong) SKEntityList * designs;
@property (strong) SKEntityList * articles;
@property (strong) SKEntityList * productTypes;
@property (strong) SKEntityList * productTypeDepartments;
@property (strong) SKEntityList * printTypes;
@property (strong) SKEntityList * baskets;
@property (strong) SKEntityList * currencies;
@property (strong) SKEntityList * languages;
@property (strong) SKEntityList * countries;

@end
