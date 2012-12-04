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

@implementation SPBasketManager

@synthesize basket;

- (id)init
{
    if (self = [super init]) {
        self.basket = [[SPBasket alloc] init];
    }
    return self;
}

- (void)addItem:(SPBasketItem *)item
{
    [self.basket.basketItems addObject:item];
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
