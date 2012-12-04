//
//  SPConfigurationOffset.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@interface SPOffset : SPEntity

@property (nonatomic, strong) NSString * unit;
@property (nonatomic, strong) NSNumber * x;
@property (nonatomic, strong) NSNumber * y;

@end
