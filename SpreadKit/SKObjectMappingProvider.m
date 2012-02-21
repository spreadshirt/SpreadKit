//
//  SKObjectMappingProvider.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectMappingProvider.h"

@implementation SKObjectMappingProvider

- (id)init
{
    self = [super init];
    if (self){
        
        // resource mapping
        RKManagedObjectMapping *resourceMapping = [RKManagedObjectMapping mappingForEntityWithName:@"SKResource"];
        
        [resourceMapping mapAttributes:@"mediaType", @"type", nil];
        [resourceMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        [self setMapping:resourceMapping forKeyPath:@"resources"];
        
        // product mapping
        RKManagedObjectMapping *productMapping = [RKManagedObjectMapping mappingForEntityWithName:@"SKProduct"];
        
        [productMapping mapAttributes:@"name", @"weight", @"creator", nil];
        [productMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        productMapping.primaryKeyAttribute = @"identifier";
        [self setMapping:productMapping forKeyPath:@"products"];
    }
    return self;
}

@end
