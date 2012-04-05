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

static SKObjectMappingProvider *sharedMappingProvider = nil;

@implementation SKObjectMappingProvider

- (id)init
{
    self = [super init];
    if (self){
        // All the predifined mappings
        
        // resource mapping
        [RKObjectMapping mappingForClass:[SKResource class] block:^(RKObjectMapping *mapping) {
            [mapping mapAttributes:@"mediaType", @"type", nil];
            [mapping mapKeyPath:@"href" toAttribute:@"url"];
            mapping.rootKeyPath = @"resources";
            [self setMapping:mapping forKeyPath:mapping.rootKeyPath];
        }];
        
        // user mapping
        [RKObjectMapping mappingForClass:[SKUser class] block:^(RKObjectMapping *mapping) {
            [mapping mapKeyPath:@"id" toAttribute:@"identifier"];
            [mapping mapKeyPath:@"href" toAttribute:@"url"];
            [mapping mapAttributes:@"name", nil];
            [self setMapping:mapping forKeyPath:@"user"];
        }];
        
        // shop mapping
        [RKObjectMapping mappingForClass:[SKShop class] block:^(RKObjectMapping *mapping) {
            
        }];
        
        // product mapping
        [RKObjectMapping mappingForClass:[SKProduct class] block:^(RKObjectMapping *mapping) {
            [mapping mapAttributes:@"name", @"weight", @"creator", nil];
            [mapping mapKeyPath:@"href" toAttribute:@"url"];
            [mapping mapKeyPath:@"id" toAttribute:@"identifier"];
            [mapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:[self objectMappingForClass:[SKResource class]]];
            mapping.rootKeyPath = @"products";
            [mapping mapKeyPath:@"user" toRelationship:@"user" withMapping:[self objectMappingForClass:[SKUser class]]];
            [self setMapping:mapping forKeyPath:mapping.rootKeyPath];
        }];
        
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
