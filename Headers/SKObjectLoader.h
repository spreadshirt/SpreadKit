//
//  SKObjectLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class SKEntityList;

@interface SKObjectLoader : NSObject

- (void)get:(id)objectStub completion:(void (^)(id loaded, NSError *error))completion;

- (void)getSingleObjectStub:(id)theStub completion:(void (^)(id loaded, NSError *error))completion;

- (void)getEntityList:(SKEntityList *)list completion:(void (^)(SKEntityList *list, NSError *error))completion;

- (void)getSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *objects, NSError *error))completion;

// loads the entity list elements, taking into account the offset and limit
- (void)getEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *list, NSError *error))completion;

- (void)getResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)params mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target completion:(void (^)(NSArray *objects, NSError *error))completion;

@end
