//
//  SPProductConfiguration.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPPrintArea;
@class SPPrintType;
@class SPOffset;
@class SPViewSize;
@class SPSVG;

@interface SPProductConfiguration : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) SPPrintArea * printArea;
@property (nonatomic, strong) SPPrintType * printType;
@property (nonatomic, strong) SPOffset * offset;
@property (nonatomic, strong) SPSVG * content;
@property (nonatomic, strong) NSArray * designs;
@property (nonatomic, strong) NSArray * fontFamilies;
@property (nonatomic, strong) NSDictionary * restrictions;
@property (nonatomic, strong) NSArray * resources;
@property (readonly) SPViewSize * size;

@end
