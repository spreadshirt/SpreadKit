//
//  SPBasketItem.m
//  SpreadKit
//
//  Created by Sebastian Marr on 08.06.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPBasketItem.h"

#import "SPArticle.h"
#import "SPProduct.h"
#import "SPAppearance.h"
#import "SPSize.h"

@implementation SPBasketItem

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

    [elementMDict setObject:[[item url] absoluteString] forKey:@"href"];
    
    if ([item isKindOfClass:[SPArticle class]]) {
        [elementMDict setObject:@"sprd:article" forKey:@"type"];
    } else if ([item isKindOfClass:[SPProduct class]]) {
        [elementMDict setObject:@"sprd:product" forKey:@"type"];
    }
    
    self.element = [NSDictionary dictionaryWithDictionary:elementMDict];
}

- (void)setAppearance:(SPAppearance *)theAppearance
{
    appearance = theAppearance;
    
    NSMutableDictionary * elementMDict = [NSMutableDictionary dictionaryWithDictionary:element];
    
    NSMutableArray * propertiesMArray = [NSMutableArray arrayWithArray:[elementMDict objectForKey:@"properties"]];
    
    
    NSMutableDictionary *appearanceMDict;
    // check if properties already contains appearance and override or create
    BOOL containsAppearance = NO;
    for (NSDictionary *obj in propertiesMArray) {
        if ([[obj objectForKey:@"key"] isEqualToString:@"appearance"]) {
            appearanceMDict = [NSMutableDictionary dictionaryWithDictionary:obj];
            containsAppearance = YES;
        }
    }
    
    if (!containsAppearance) {
        appearanceMDict = [NSMutableDictionary dictionaryWithObject:@"appearance" forKey:@"key"];
        [propertiesMArray addObject:appearanceMDict];
    }
    
    [appearanceMDict setObject:appearance.identifier forKey:@"value"];
    
    [elementMDict setObject:[NSArray arrayWithArray:propertiesMArray] forKey:@"properties"];
    self.element = [NSDictionary dictionaryWithDictionary:elementMDict];
}

- (void)setSize:(SPSize *)theSize
{
    size = theSize;
    
    NSMutableDictionary * elementMDict = [NSMutableDictionary dictionaryWithDictionary:element];
    
    NSMutableArray * propertiesMArray = [NSMutableArray arrayWithArray:[elementMDict objectForKey:@"properties"]];
    
    
    NSMutableDictionary *appearanceMDict;
    // check if properties already contains appearance and override or create
    BOOL containsSize = NO;
    for (NSDictionary *obj in propertiesMArray) {
        if ([[obj objectForKey:@"key"] isEqualToString:@"size"]) {
            appearanceMDict = [NSMutableDictionary dictionaryWithDictionary:obj];
            containsSize = YES;
        }
    }
    
    if (!containsSize) {
        appearanceMDict = [NSMutableDictionary dictionaryWithObject:@"size" forKey:@"key"];
        [propertiesMArray addObject:appearanceMDict];
    }
    
    [appearanceMDict setObject:size.identifier forKey:@"value"];
    
    [elementMDict setObject:[NSArray arrayWithArray:propertiesMArray] forKey:@"properties"];
    self.element = [NSDictionary dictionaryWithDictionary:elementMDict];
}

@end
