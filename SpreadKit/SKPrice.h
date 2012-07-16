//
//  SKPrice.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKCurrency;

@interface SKPrice : NSObject

@property (nonatomic, strong) NSNumber * vatExcluded;
@property (nonatomic, strong) NSNumber * vatIncluded;
@property (nonatomic, strong) NSNumber * vat;
@property (nonatomic, strong) SKCurrency * currency;

@end
