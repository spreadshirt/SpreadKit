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

- (void)loadSingleEntityFromUrl:(NSURL *)url mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

- (void)loadEntityListFromUrl:(NSURL *)url onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

- (void)loadResourceFromUrl:(NSURL *)theUrl mappingProvdider:(RKObjectMappingProvider *)mappingProvider onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

- (void)load:(id)objectStub onSuccess:(void (^)(void))success onFailure:(void (^)(NSError *))failure;

@end
