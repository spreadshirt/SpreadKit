//
//  SKSVG.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@class SKViewSize;

@interface SKSVG : SKEntity

@property NSString * transform;
@property NSString * printColorIds;
@property SKViewSize * size;

@end
