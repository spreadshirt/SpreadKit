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
@class SKConfigurationOffset;

@interface SKProductConfiguration : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) SKPrintArea * printArea;
@property (nonatomic, strong) SKPrintType * printType;
@property (nonatomic, strong) SKConfigurationOffset * offset;
@property (nonatomic, strong) NSDictionary * content;
@property (nonatomic, strong) NSArray * designs;
@property (nonatomic, strong) NSArray * fontFamilies;
@property (nonatomic, strong) NSDictionary * restrictions;
@property (nonatomic, strong) NSArray * resources;

@end
