//
//  SPObjectMapper.h
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class SPObjectMappingProvider;

@interface SPObjectMapper : NSObject

+ (SPObjectMapper *)mapperWithMIMEType:(NSString *)mimeType objectClass:(Class)class;

+ (SPObjectMapper *)mapperWithMIMEType:(NSString *)mimeType objectClass:(Class)class andDestinationObject:(id)dest;

- (id)performMappingWithData:(NSData *)data;

- (NSString *)serializeObject:(id)theObject;

- (id)initWithMIMEType:(NSString *)mimeType objectClass:(Class)theClass;

- (id)initWithMIMEType:(NSString *)mimeType objectClass:(Class)class andDestinationObject:(id)dest;


@end
