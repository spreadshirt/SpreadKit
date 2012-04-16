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

+ (SKObjectMapper *) mapperWithMIMEType:(NSString *)mimeType data:(NSData *)data mappingProvider:(RKObjectMappingProvider *)mappingProvider;

- (id)performMapping;

- (id)initWithMIMEType:(NSString *)mimeType data:(NSData *)data mappingProvider:(RKObjectMappingProvider *)mappingProvider;

@end
