//
//  SPBasketManager.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPBasketManager.h"
#import "SPBasket.h"
#import "SPClient.h"
#import "SPURLConnection.h"
#import "SPBasketItem.h"

@implementation SPBasketManager

@synthesize basket;

- (id)init
{
    if (self = [super init]) {
        self.basket = [[SPBasket alloc] init];
    }
    return self;
}

- (SPBasketItem *)addToBasket:(id)productOrArticle withSize:(SPSize *)size andAppearance:(SPAppearance *)appearance
{
    SPBasketItem *item = [[SPBasketItem alloc] init];
    item.item = productOrArticle;
    item.size = size;
    item.appearance = appearance;
    item.quantity = @1;
    
    [self.basket.basketItems addObject:item];
    
    return item;
}

- (void)removeItem:(SPBasketItem *)item
{
    [self.basket.basketItems removeObject:item];
}

- (NSArray *)items
{
    return self.basket.basketItems;
}

- (void)checkoutURLWithCompletion:(void (^)(NSURL *checkoutURL, NSError* error))completion
{
    [[SPClient sharedClient] post:basket completion:^(id newObject, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            [[SPClient sharedClient] get:basket completion:^(id loadedBasket, NSError *error) {
                [[loadedBasket links] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([[obj objectForKey:@"type"] isEqualToString:@"platformCheckout"]) {
                        NSURL *checkout = [NSURL URLWithString:[obj objectForKey:@"href"]];
                        completion(checkout, nil);
                    }
                }];
            }];
        }
    }];
}

@end
