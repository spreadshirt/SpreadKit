//
//  SPPrice.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SPEntity.h"

@class SPCurrency;

@interface SPPrice : SPEntity

@property (nonatomic, strong) NSNumber * vatExcluded;
@property (nonatomic, strong) NSNumber * vatIncluded;
@property (nonatomic, strong) NSNumber * vat;
@property (nonatomic, strong) SPCurrency * currency;

@end
