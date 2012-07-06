//
//  SKBasketManager.m
//  SpreadKit
//
//  Created by Sebastian Marr on 02.07.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKBasketManager.h"
#import "SKObjectPoster.h"
#import "SKClient.h"
#import "SKObjectMappingProvider.h"
#import "SKObjectLoader.h"

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
    // get basket url if not already available
    if (!basket.url) {
        SKObjectPoster *poster = [[SKObjectPoster alloc] init];
        [poster postObject:basket toURL:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/baskets?mediaType=json"] apiKey:[SKClient sharedClient].apiKey secret:[SKClient sharedClient].secret mappingProvider:[SKObjectMappingProvider sharedMappingProvider] completion:^(id object, NSError *error) {
            // load checkout reference
            SKObjectLoader *loader = [[SKObjectLoader alloc] init];
            NSDictionary *params = [NSDictionary dictionaryWithObject:@"json" forKey:@"mediaType"];
            [loader loadResourceFromUrl:[NSURL URLWithString:@"/checkout" relativeToURL:[object url]] withParams:params mappingProvdider:[SKObjectMappingProvider sharedMappingProvider] intoTargetObject:nil completion:^(NSArray *objects, NSError *error) {
                
            }];
        }];
    }
}

@end
