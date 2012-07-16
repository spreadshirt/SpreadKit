//
//  SKObjectMapper.h
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class SKObjectMappingProvider;

@interface SKObjectMapper : NSObject

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider;

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest;

- (id)performMappingWithData:(NSData *)data;

- (NSString *)serializeObject:(id)theObject;

- (id)initWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider;

- (id)initWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest;


@end
