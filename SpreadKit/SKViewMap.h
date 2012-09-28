//
//  SKViewMap.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@class SKOffset;

@interface SKViewMap : SKEntity

@property (nonatomic, strong) NSString *printAreaId;
@property (nonatomic, strong) SKOffset *offset;

@end
