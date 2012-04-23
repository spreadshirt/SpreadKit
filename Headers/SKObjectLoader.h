//
//  SKObjectLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SKObjectLoader : NSObject <NSURLConnectionDelegate>

- (void)load:(id)objectStub onSuccess:(void (^)(id loaded))success onFailure:(void (^)(NSError *))failure;

- (void)loadSingleObjectStub:(id)theStub onSuccess:(void (^)(id loaded))sucess onFailure:(void (^)(NSError *error))failure;

- (void)loadSingleEntityFromUrl:(NSURL *)url intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

- (void)loadEntityListFromUrl:(NSURL *)url onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

- (void)loadResourceFromUrl:(NSURL *)theUrl mappingProvdider:(RKObjectMappingProvider *)mappingProvider intoTargetObject:(id)target onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

@end
