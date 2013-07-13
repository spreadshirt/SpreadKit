//
//  SPObjectMappingProvider.h
//  SpreadKit
//
//  Created by Sebastian Marr on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SPObjectMappingProvider : NSObject

@property (nonatomic, readonly) NSDictionary *mappingsDictionary;

+ (SPObjectMappingProvider *)sharedMappingProvider;
- (RKObjectMapping *)objectMappingForClass:(Class)class;
- (RKObjectMapping *)serializationMappingForClass:(Class)class;
@end
