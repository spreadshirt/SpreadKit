//
//  SKObjectLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SKObjectMappingProvider.h"

@protocol SKObjectLoaderDelegate <NSObject>

@optional
- (void)loader:(id)theLoader didLoadObjects:(NSArray *)objects;
- (void)loader:(id)theLoader didFailWithError:(NSError *)error;
@end

@interface SKObjectLoader : NSObject <NSURLConnectionDelegate>

@property (weak) id<SKObjectLoaderDelegate> delegate;

- (void)loadSingleEntityFromUrl:(NSString *)url mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;
- (void)loadEntityListFromUrl:(NSString *)url mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

@end
