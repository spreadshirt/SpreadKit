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

@interface SKShop : NSObject

@property (strong) NSURL * url;
@property (strong) NSString * identifier;
@property (strong) NSString * name;
@property (strong) SKUser * user;
@property (strong) SKEntityList * products;
@property (strong) SKEntityList * articles;
@property (strong) SKEntityList * productTypes;

@end
