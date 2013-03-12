//
//  SPBasketManager.h
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPBasketItem;
@class SPBasket;
@class SPSize;
@class SPAppearance;

@interface SPBasketManager : NSObject

@property (nonatomic, strong) SPBasket *basket;

- (SPBasketItem *)addToBasket:(id)productOrArticle withSize:(SPSize *)size andAppearance:(SPAppearance *)appearance;
- (void)removeItem:(SPBasketItem *)item;
- (NSArray *)items;
- (void)checkoutURLWithCompletion:(void (^)(NSURL *checkoutURL, NSError* error))completion;

@end
