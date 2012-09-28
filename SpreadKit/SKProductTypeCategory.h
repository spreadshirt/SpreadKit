//
//  SKProductTypeCategory.h
//  SpreadKit
//
//  Created by Sebastian Marr on 10.09.12.
//
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@interface SKProductTypeCategory : SKEntity

@property NSString * identifier;
@property NSString * name;
@property NSString * nameSingular;
@property NSArray * productTypes;

@end
