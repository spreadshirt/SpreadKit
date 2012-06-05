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
#import "NSSet+SpreadKit.h"
#import "SKEntityList.h"
#import "SKAppearance.h"
#import "SKArticle.h"

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
                
        RKObjectMapping *productTypeMapping = [RKObjectMapping mappingForClass:[SKProductType class]];
        [productTypeMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productTypeMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productTypeMapping mapAttributes:@"sizes", @"appearences", @"weight", @"name", @"shortDescription", @"description", @"categoryName", @"brand", @"shippingFactor", @"sizeFitHint", @"price", @"defaultValues", @"sizes", @"washingInstructions", @"views", @"printAreas", @"stockStates", @"resources", nil];

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
        
        // relationships
        [appearanceMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [productMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [productMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [productMapping mapKeyPath:@"productType" toRelationship:@"productType" withMapping:productTypeMapping];
        
        [productTypeMapping mapKeyPath:@"appearances" toRelationship:@"appearances" withMapping:appearanceMapping];
        
        [articleMapping mapKeyPath:@"shop" toRelationship:@"shop" withMapping:shopMapping];
        [articleMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:productMapping];
        [articleMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [userMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        
        [shopMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        [shopMapping mapKeyPath:@"articles" toRelationship:@"articles" withMapping:listMapping];

        
        // mapping registrations
        [self addObjectMapping:userMapping];
        [self addObjectMapping:listMapping];
        [self addObjectMapping:appearanceMapping];
        [self addObjectMapping:productTypeMapping];
        [self addObjectMapping:productMapping];
        [self addObjectMapping:articleMapping];
        [self setMapping:articleMapping forKeyPath:@"articles"];
        [self setMapping:shopMapping forKeyPath:@"shop"];
        [self setMapping:userMapping forKeyPath:@"user"];
        [self setMapping:productMapping forKeyPath:@"products"];
        [self setMapping:productTypeMapping forKeyPath:@"productType"];
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
