//
//  SPSize.h
//  SpreadKit
//
//  Created by Sebastian Marr on 07.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@interface SPSize : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDictionary * measures;

@end
