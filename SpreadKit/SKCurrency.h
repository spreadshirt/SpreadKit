//
//  SKCurrency.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@interface SKCurrency : SKEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * plain;
@property (nonatomic, strong) NSString * isoCode;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSNumber * decimalCount;
@property (nonatomic, strong) NSString * pattern;

@end
