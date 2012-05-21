//
//  SKObjectMapper.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKObjectMapper.h"

@implementation SKObjectMapper
{
    RKObjectMappingProvider *provider;
    NSString *mimeType;
    id destinationObject;
}

- (id)initWithMIMEType:(NSString *)theMimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    return [self initWithMIMEType:theMimeType mappingProvider:mappingProvider andDestinationObject:nil];
}

- (id)initWithMIMEType:(NSString *)theMimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest
{
    if (self = [super init]) {
        provider = mappingProvider;
        mimeType = theMimeType;
        destinationObject = dest;
    }
    return self;
}

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    return [[self alloc] initWithMIMEType:mimeType mappingProvider:mappingProvider];
}

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest
{
    return [[self alloc] initWithMIMEType:mimeType mappingProvider:mappingProvider andDestinationObject:dest];
}

- (id)performMappingWithData:(NSData *)data
{
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // do the mapping
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:mimeType];
    id parsedData = [parser objectFromString:stringData error:nil];
    RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:provider];
    if (destinationObject) {
        mapper.targetObject = destinationObject;
    }
    RKObjectMappingResult *result = [mapper performMapping];
    
    return [result asCollection];
}

@end
