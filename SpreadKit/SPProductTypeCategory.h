//
//  SPProductTypeCategory.h
//  SpreadKit
//
//  Created by Sebastian Marr on 10.09.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@interface SPProductTypeCategory : SPEntity

@property NSString * identifier;
@property NSString * name;
@property NSString * nameSingular;
@property NSArray * productTypes;

@end
