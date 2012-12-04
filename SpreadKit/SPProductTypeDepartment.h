//
//  SPProductTypeDepartment.h
//  SpreadKit
//
//  Created by Sebastian Marr on 10.09.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@interface SPProductTypeDepartment : SPEntity

@property NSString * identifier;
@property NSURL * url;
@property NSNumber * weight;
@property NSArray * categories;
@property NSString * name;

@end
