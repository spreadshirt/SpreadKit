//
//  SKAppearance.h
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@interface SKAppearance : SKEntity

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *printTypes;
@property (nonatomic, strong) NSArray *resources;

@end
