//
//  SKBasketManager.h
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SKBasketItem;
@class SKBasket;

@interface SKBasketManager : NSObject

@property (nonatomic, strong) SKBasket *basket;

- (void)addItem:(SKBasketItem *)item;
- (void)removeItem:(SKBasketItem *)item;
- (NSArray *)items;
- (void)checkoutURLWithCompletion:(void (^)(NSURL *checkoutURL, NSError* error))completion;

@end
