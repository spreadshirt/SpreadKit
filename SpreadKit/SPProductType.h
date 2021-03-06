//
//  ProductType.h
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPPrice;
@class SPAppearance;
@class SPView;
@class SPPrintArea;

@interface SPProductType : SPEntity

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
@property (nonatomic, strong) SPPrice * price;
@property (nonatomic, strong) NSDictionary * defaultValues;
@property (nonatomic, strong) NSArray * sizes;
@property (nonatomic, strong) NSArray * appearances;
@property (nonatomic, strong) NSArray * washingInstructions;
@property (nonatomic, strong) NSArray * views;
@property (nonatomic, strong) NSArray * printAreas;
@property (nonatomic, strong) NSArray * stockStates;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong, readonly) SPView * defaultView;
@property (nonatomic, strong, readonly) SPAppearance * defaultAppearance;

- (SPPrintArea *) printAreaById: (NSString *) printAreaId;
- (SPPrintArea *) printAreaForView: (SPView *) view;

@end
