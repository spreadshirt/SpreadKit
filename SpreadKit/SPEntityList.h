//
//  SPEntityList.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPEntityList : NSObject <NSFastEnumeration>

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSArray * elements;
@property (nonatomic, strong) NSNumber * offset;
@property (nonatomic, strong) NSNumber * limit;
@property (nonatomic, strong) NSNumber * count;

@end