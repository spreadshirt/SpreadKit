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

@interface SKObjectLoader : NSObject <NSURLConnectionDelegate>

- (void)load:(id)objectStub completion:(void (^)(id loaded, NSError *error))completion;

- (void)loadSingleObjectStub:(id)theStub completion:(void (^)(id loaded, NSError *error))completion;

- (void)loadEntityList:(SKEntityList *)list completion:(void (^)(SKEntityList *list, NSError *error))completion;

- (void)loadSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *objects, NSError *error))completion;

// loads the entity list elements, taking into account the offset and limit
- (void)loadEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *list, NSError *error))completion;

- (void)loadResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)params mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target completion:(void (^)(NSArray *objects, NSError *error))completion;

@end
