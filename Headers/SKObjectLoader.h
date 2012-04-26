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

- (void)load:(id)objectStub onSuccess:(void (^)(id loaded))success onFailure:(void (^)(NSError *))failure;

- (void)loadSingleObjectStub:(id)theStub onSuccess:(void (^)(id loaded))sucess onFailure:(void (^)(NSError *error))failure;

- (void)loadEntityList:(SKEntityList *)list onSuccess:(void (^)(NSArray *objects))sucess onFailure:(void (^)(NSError *error))failure;

- (void)loadSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

// loads the entity list elements, taking into account the offset and limit
- (void)loadEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

- (void)loadResourceFromUrl:(NSURL *)theUrl withParams:(NSDictionary *)params mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

@end
