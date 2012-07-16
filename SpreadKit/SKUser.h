//
//  SKUser.h
//  SpreadKit
//
//  Created by Sebastian Marr on 05.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKEntityList;

@interface SKUser : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) SKEntityList * products;
@property (nonatomic, strong) SKEntityList * designs;
@property (nonatomic, strong) NSDate *memberSince;
@property (nonatomic, strong) SKEntityList * baskets;

@end
