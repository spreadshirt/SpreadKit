//
//  SKObjectPoster.h
//  SpreadKit
//
//  Created by Sebastian Marr on 11.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SKObjectPoster : NSObject

- (void)postObject:(id)theObject toURL:(NSURL *)theURL mappingProvider:(RKObjectMappingProvider *)mappingProvider onSuccess:(void (^)(id object))success onFailure:(void (^)(NSError *error))failure;

@end