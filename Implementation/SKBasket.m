//
//  SKBasket.m
//  SpreadKit
//
//  Created by Sebastian Marr on 10.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKBasket.h"

@implementation SKBasket

@synthesize url, token, shop, user, basketItems, identifier;

- (id)init
{
    if (self = [super init]) {
        basketItems = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
