//
//  SPCountry.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPCurrency;

@interface SPCountry : SPEntity

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * isoCode;
@property (nonatomic, strong) NSString * thousandsSeparator;
@property (nonatomic, strong) NSString * decimalPoint;
@property (nonatomic, strong) NSString * lengthUnit;
@property (nonatomic, strong) NSNumber * lengthFactor;
@property (nonatomic, strong) SPCurrency * currency;

@end
