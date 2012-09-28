//
//  SKConfigurationOffset.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@interface SKOffset : SKEntity

@property (nonatomic, strong) NSString * unit;
@property (nonatomic, strong) NSNumber * x;
@property (nonatomic, strong) NSNumber * y;

@end
