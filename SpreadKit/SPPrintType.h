//
//  SPPrintType.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPSize;
@class SPPrice;

@interface SPPrintType : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) SPSize * size;
@property (nonatomic, strong) NSNumber * dpi;
@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, strong) NSDictionary * restrictions;
@property (nonatomic, strong) SPPrice * price;

@end
