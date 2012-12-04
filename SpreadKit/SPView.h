//
//  SPView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPViewSize;
@class SPViewMap;

@interface SPView : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) SPViewSize * size;
@property (nonatomic, strong) NSString * perspective;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong) NSArray * viewMaps;

- (SPViewMap *) viewMapByPrintAreaId: (NSString *)printAreaId;

@end
