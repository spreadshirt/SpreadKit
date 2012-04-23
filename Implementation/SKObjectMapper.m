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
    NSData *data;
    id destinationObject;
}

- (id)initWithMIMEType:(NSString *)theMimeType data:(NSData *)theData mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    return [self initWithMIMEType:theMimeType data:theData mappingProvider:mappingProvider andDestinationObject:nil];
}

- (id)initWithMIMEType:(NSString *)theMimeType data:(NSData *)theData mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest
{
    if (self = [super init]) {
        provider = mappingProvider;
        mimeType = theMimeType;
        data = theData;
        destinationObject = dest;
    }
    return self;
}

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType data:(NSData *)data mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    return [[self alloc] initWithMIMEType:mimeType data:data mappingProvider:mappingProvider];
}

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType data:(NSData *)data mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest
{
    return [[self alloc] initWithMIMEType:mimeType data:data mappingProvider:mappingProvider andDestinationObject:dest];
}

- (id)performMapping
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
