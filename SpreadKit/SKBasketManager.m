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
#import "SKURLConnection.h"

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
            // retrieve checkout URL
            NSURL *checkoutRetrieval = [NSURL URLWithString:[NSString stringWithFormat:@"%@/checkout?mediaType=json", [newObject url].absoluteString]];
            [SKURLConnection get:checkoutRetrieval params:nil apiKey:[SKClient sharedClient].apiKey secret:[SKClient sharedClient].secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                NSError *decodeError;
                id decoded = [[JSONDecoder decoder] objectWithData:data error:&decodeError];
                if (decodeError) {
                    completion(nil, decodeError);
                } else {
                    NSURL *COURL = [NSURL URLWithString:[decoded objectForKey:@"href"]];
                    completion(COURL, nil);
                }
            }];
        }
    }];
}

@end
