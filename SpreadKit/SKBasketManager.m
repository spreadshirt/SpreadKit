//
//  SKBasketManager.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKBasketManager.h"
#import "SKBasket.h"
#import "SKClient.h"

@implementation SKBasketManager

@synthesize basket;

- (id)init
{
    if (self = [super init]) {
        self.basket = [[SKBasket alloc] init];
    }
    return self;
}

- (void)addItem:(SKBasketItem *)item
{
    [self.basket.basketItems addObject:item];
}

- (void)removeItem:(SKBasketItem *)item
{
    [self.basket.basketItems removeObject:item];
}

- (NSArray *)items
{
    return self.basket.basketItems;
}

- (void)checkoutURLWithCompletion:(void (^)(NSURL *checkoutURL, NSError* error))completion
{
    [[SKClient sharedClient] post:basket completion:^(id newObject, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            // TODO: workaround, just posting will be sufficient later
            [[SKClient sharedClient] put:newObject completion:^(id updatedObject, NSError *error) {
                NSLog(@"%@", [newObject url]);
            }];
        }
    }];
}

@end
