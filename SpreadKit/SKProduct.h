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
@class SKProductType;
@class SKAppearance;

@interface SKProduct : NSObject

@property (nonatomic, strong) NSString * creator;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSArray *resources;
@property (nonatomic, strong) SKUser *user;
@property (nonatomic, strong) SKProductType *productType;
@property (nonatomic, strong) NSDictionary* restrictions;
@property (nonatomic, strong) SKAppearance *appearance;
@property (nonatomic, strong) NSArray *configurations;
@property (nonatomic) BOOL freeColorSelection;

@end
