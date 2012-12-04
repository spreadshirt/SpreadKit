//
//  SPSVG.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPViewSize;

@interface SPSVG : SPEntity

@property NSString * transform;
@property NSString * printColorIds;
@property SPViewSize * size;

@end
