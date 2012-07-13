//
//  SKObjectMappingProvider.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectMappingProvider.h"
#import "SKResource.h"
#import "SKProduct.h"
#import "SKUser.h"
#import "SKShop.h"
#import "SKProductType.h"
#import "SKEntityList.h"
#import "SKAppearance.h"
#import "SKArticle.h"
#import "SKSize.h"
#import "SKBasket.h"
#import "SKBasketItem.h"
#import "SKDesign.h"

static SKObjectMappingProvider *sharedMappingProvider = nil;

@implementation SKObjectMappingProvider

- (id)init
{
    self = [super init];
    if (self){
        
        // date formatting
        [RKObjectMapping addDefaultDateFormatterForString:@"dd-MMM-yyyy" inTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        
        RKObjectMapping *resourceMapping = [RKObjectMapping mappingForClass:[SKResource class]];
        [resourceMapping mapAttributes:@"mediaType", @"type", nil];
        [resourceMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        RKObjectMapping *appearanceMapping = [RKObjectMapping mappingForClass:[SKAppearance class]];
        [appearanceMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [appearanceMapping mapAttributes:@"name", @"colors", @"printTypes", nil];
        
        RKObjectMapping *sizeMapping = [RKObjectMapping mappingForClass:[SKSize class]];
        [sizeMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [sizeMapping mapAttributes:@"name", @"measures", nil];
                
        RKObjectMapping *productTypeMapping = [RKObjectMapping mappingForClass:[SKProductType class]];
        [productTypeMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productTypeMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productTypeMapping mapAttributes:@"appearences", @"weight", @"name", @"shortDescription", @"description", @"categoryName", @"brand", @"shippingFactor", @"sizeFitHint", @"price", @"defaultValues", @"washingInstructions", @"views", @"printAreas", @"stockStates", nil];

        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SKProduct class]];
        [productMapping mapAttributes:@"name", @"weight", @"creator", @"restrictions", nil];
        [productMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        
        RKObjectMapping *articleMapping = [RKObjectMapping mappingForClass:[SKArticle class]];
        [articleMapping mapAttributes:@"weight", @"name", @"description", @"price", @"articleCategories", @"created", @"modified", nil];
        [articleMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [articleMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        NSDateFormatter *articleDateFormatter = [NSDateFormatter new];
        articleDateFormatter.dateFormat = @"dd.MM.yyyy hh:mm:ss";
        articleDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        articleMapping.dateFormatters = [NSArray arrayWithObject:articleDateFormatter];
            
        RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[SKEntityList class]];
        [listMapping mapKeyPath:@"href" toAttribute:@"url"];
        [listMapping mapAttributes:@"count", @"offset", @"limit", nil];
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[SKUser class]];
        [userMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [userMapping mapKeyPath:@"href" toAttribute:@"url"];
        [userMapping mapAttributes:@"name", @"description", @"memberSince", nil];
        
        RKObjectMapping *shopMapping = [RKObjectMapping mappingForClass:[SKShop class]];
        [shopMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [shopMapping mapKeyPath:@"href" toAttribute:@"url"];
        [shopMapping mapAttributes:@"name", nil];
        
        RKObjectMapping *basketMapping = [RKObjectMapping mappingForClass:[SKBasket class]];
        [basketMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [basketMapping mapKeyPath:@"href" toAttribute:@"url"];
        [basketMapping mapAttributes:@"token", nil];
        
        RKObjectMapping *basketItemMapping = [RKObjectMapping mappingForClass:[SKBasketItem class]];
        [basketItemMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [basketItemMapping mapAttributes:@"description", @"quantity", @"links", @"price", @"origin", @"element", nil];
        
        RKObjectMapping *designMapping = [RKObjectMapping mappingForClass:[SKDesign class]];
        [designMapping mapAttributes:@"name", @"weight", @"description", @"sourceUrl", @"restrictions", @"colors", @"printTypes", @"price", @"created", @"modified", @"size", nil];
        [designMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [designMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        // relationships
        [appearanceMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [productMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [productMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [productMapping mapKeyPath:@"productType" toRelationship:@"productType" withMapping:productTypeMapping];
        [productMapping mapKeyPath:@"appearance" toRelationship:@"appearance" withMapping:appearanceMapping];
        
        [productTypeMapping mapKeyPath:@"appearances" toRelationship:@"appearances" withMapping:appearanceMapping];
        [productTypeMapping mapKeyPath:@"sizes" toRelationship:@"sizes" withMapping:sizeMapping];
        [productTypeMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [articleMapping mapKeyPath:@"shop" toRelationship:@"shop" withMapping:shopMapping];
        [articleMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:productMapping];
        [articleMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [userMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        [userMapping mapKeyPath:@"designs" toRelationship:@"designs" withMapping:listMapping];
        [userMapping mapKeyPath:@"baskets" toRelationship:@"baskets" withMapping:listMapping];
        
        [shopMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        [shopMapping mapKeyPath:@"articles" toRelationship:@"articles" withMapping:listMapping];
        [shopMapping mapKeyPath:@"productTypes" toRelationship:@"productTypes" withMapping:listMapping];
        [shopMapping mapKeyPath:@"designs" toRelationship:@"designs" withMapping:listMapping];
        [shopMapping mapKeyPath:@"baskets" toRelationship:@"baskets" withMapping:listMapping];
        
        [basketMapping mapKeyPath:@"shop" toRelationship:@"shop" withMapping:shopMapping];
        [basketMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [basketMapping mapKeyPath:@"basketItems" toRelationship:@"basketItems" withMapping:basketItemMapping];
        
        [designMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [designMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        
        // serialization mappings
        
        RKObjectMapping *basketSerializationMapping = [basketMapping inverseMapping];
        RKObjectMapping *designSerializationMapping = [designMapping inverseMapping];
        
        [self setSerializationMapping:basketSerializationMapping forClass:[SKBasket class]];
        [self setSerializationMapping:designSerializationMapping forClass:[SKDesign class]];
        
        // mapping registrations
        [self addObjectMapping:userMapping];
        [self addObjectMapping:listMapping];
        [self addObjectMapping:appearanceMapping];
        [self addObjectMapping:productTypeMapping];
        [self addObjectMapping:productMapping];
        [self addObjectMapping:articleMapping];
        [self addObjectMapping:basketMapping];
        [self addObjectMapping:basketItemMapping];
        [self addObjectMapping:designMapping];
        [self setMapping:articleMapping forKeyPath:@"articles"];
        [self setMapping:shopMapping forKeyPath:@"shop"];
        [self setMapping:userMapping forKeyPath:@"user"];
        [self setMapping:productMapping forKeyPath:@"products"];
        [self setMapping:productTypeMapping forKeyPath:@"productTypes"];
        [self setMapping:basketItemMapping forKeyPath:@"basketItems"];
        [self setMapping:designMapping forKeyPath:@"designs"];
        [self setMapping:basketMapping forKeyPath:@"baskets"];
    }
    return self;
}

+ (SKObjectMappingProvider *)sharedMappingProvider
{
    if (sharedMappingProvider == nil) {
        sharedMappingProvider = (SKObjectMappingProvider* )[SKObjectMappingProvider mappingProvider];
    }
    return sharedMappingProvider;
}

@end
