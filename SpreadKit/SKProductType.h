//
//  ProductType.h
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKPrice;

@interface SKProductType : NSObject

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * shortDescription;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * brand;
@property (nonatomic, strong) NSNumber * shippingFactor;
@property (nonatomic, strong) NSString * sizeFitHint;
@property (nonatomic, strong) SKPrice * price;
@property (nonatomic, strong) NSDictionary * defaultValues;
@property (nonatomic, strong) NSArray * sizes;
@property (nonatomic, strong) NSArray * appearances;
@property (nonatomic, strong) NSArray * washingInstructions;
@property (nonatomic, strong) NSArray * views;
@property (nonatomic, strong) NSArray * printAreas;
@property (nonatomic, strong) NSArray * stockStates;
@property (nonatomic, strong) NSArray * resources;

@end
