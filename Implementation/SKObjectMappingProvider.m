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
#import "NSSet+SpreadKit.h"
#import "SKEntityList.h"

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
        
        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SKProduct class]];
        [productMapping mapAttributes:@"name", @"weight", @"creator", nil];
        [productMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [self addObjectMapping:productMapping];
        
        RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[SKEntityList class]];
        [listMapping mapKeyPath:@"href" toAttribute:@"url"];
        [listMapping mapAttributes:@"count", @"offset", @"limit", nil];
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[SKUser class]];
        [userMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [userMapping mapKeyPath:@"href" toAttribute:@"url"];
        [userMapping mapAttributes:@"name", @"description", @"memberSince", nil];
        [userMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        
        RKObjectMapping *shopMapping = [RKObjectMapping mappingForClass:[SKShop class]];
        [shopMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        [self setMapping:shopMapping forKeyPath:@"shop"];
        
        [self setMapping:userMapping forKeyPath:@"user"];
        [self setMapping:productMapping forKeyPath:@"products"];
                
        [productMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        
        [self addObjectMapping:userMapping];
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
