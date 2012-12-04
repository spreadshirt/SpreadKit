//
//  SPViewMap.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPOffset;

@interface SPViewMap : SPEntity

@property (nonatomic, strong) NSString *printAreaId;
@property (nonatomic, strong) SPOffset *offset;

@end
