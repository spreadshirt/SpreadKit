//
//  SKProductConfiguration.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKPrintArea;
@class SKPrintType;
@class SKOffset;
@class SKViewSize;
@class SKSVG;

@interface SKProductConfiguration : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) SKPrintArea * printArea;
@property (nonatomic, strong) SKPrintType * printType;
@property (nonatomic, strong) SKOffset * offset;
@property (nonatomic, strong) SKSVG * content;
@property (nonatomic, strong) NSArray * designs;
@property (nonatomic, strong) NSArray * fontFamilies;
@property (nonatomic, strong) NSDictionary * restrictions;
@property (nonatomic, strong) NSArray * resources;
@property (readonly) SKViewSize * size;

@end
