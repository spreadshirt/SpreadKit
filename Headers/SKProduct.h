//
//  Product.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKResource;
@class SKUser;

@interface SKProduct : NSObject

@property (nonatomic, strong) NSString * creator;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSSet *resources;
@property (nonatomic, strong) SKUser *user;
@property (nonatomic, strong) NSDictionary* restrictions;
@property (nonatomic) BOOL freeColorSelection;

@end
