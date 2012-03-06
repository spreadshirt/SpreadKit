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

@implementation SKObjectMappingProvider

- (id)init
{
    self = [super init];
    if (self){
        
        // resource mapping
        RKObjectMapping *resourceMapping = [RKObjectMapping mappingForClass:[SKResource class]];
        
        [resourceMapping mapAttributes:@"mediaType", @"type", nil];
        [resourceMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        [self setMapping:resourceMapping forKeyPath:@"resources"];
        
        // product mapping
        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SKProduct class]];
        
        [productMapping mapAttributes:@"name", @"weight", @"creator", nil];
        [productMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [self setMapping:productMapping forKeyPath:@"products"];
    }
    return self;
}

@end
