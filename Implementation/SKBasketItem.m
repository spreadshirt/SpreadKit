//
//  SKBasketItem.m
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKBasketItem.h"

#import "SKArticle.h"
#import "SKProduct.h"
#import "SKAppearance.h"
#import "SKSize.h"

@implementation SKBasketItem

@synthesize identifier;
@synthesize shop;
@synthesize description;
@synthesize origin;
@synthesize links;
@synthesize price;
@synthesize quantity;
@synthesize element;
@synthesize item;
@synthesize size;
@synthesize appearance;

- (void)setItem:(id)theItem
{
    item = theItem;
    
    NSMutableDictionary * elementMDict = [NSMutableDictionary dictionaryWithDictionary:element];

    [elementMDict setObject:[item url] forKey:@"href"];
    
    if ([item isKindOfClass:[SKArticle class]]) {
        [elementMDict setObject:@"sprd:article" forKey:@"type"];
    } else if ([item isKindOfClass:[SKProduct class]]) {
        [elementMDict setObject:@"sprd:product" forKey:@"type"];
    }
    
    self.element = [NSDictionary dictionaryWithDictionary:elementMDict];
}

- (void)setAppearance:(SKAppearance *)theAppearance
{
    appearance = theAppearance;
    
    NSMutableDictionary * elementMDict = [NSMutableDictionary dictionaryWithDictionary:element];
    
    NSMutableDictionary * propertiesMDict = [NSMutableDictionary dictionaryWithDictionary:[elementMDict objectForKey:@"properties"]];
    
    [propertiesMDict setObject:[appearance identifier] forKey:@"appearance"];
    
    [elementMDict setObject:[NSDictionary dictionaryWithDictionary:propertiesMDict] forKey:@"properties"];
    self.element = [NSDictionary dictionaryWithDictionary:elementMDict];
}

- (void)setSize:(SKSize *)theSize
{
    size = theSize;
    
    NSMutableDictionary * elementMDict = [NSMutableDictionary dictionaryWithDictionary:element];
    
    NSMutableDictionary * propertiesMDict = [NSMutableDictionary dictionaryWithDictionary:[elementMDict objectForKey:@"properties"]];
    
    [propertiesMDict setObject:[size identifier] forKey:@"size"];
    
    [elementMDict setObject:[NSDictionary dictionaryWithDictionary:propertiesMDict] forKey:@"properties"];
    self.element = [NSDictionary dictionaryWithDictionary:elementMDict];

}

@end
