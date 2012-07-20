//
//  SKViewMap.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKOffset;

@interface SKViewMap : NSObject

@property (nonatomic, strong) NSString *printAreaId;
@property (nonatomic, strong) SKOffset *offset;

@end
