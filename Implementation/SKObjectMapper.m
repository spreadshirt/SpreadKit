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
}

- (id)initWithMIMEType:(NSString *)theMimeType data:(NSData *)theData mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    if (self = [super init]) {
        provider = mappingProvider;
        mimeType = theMimeType;
        data = theData;
        
    }
    return self;
}

+ (SKObjectMapper *)mapperWithMIMEType:(NSString *)mimeType data:(NSData *)data mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    return [[self alloc] initWithMIMEType:mimeType data:data mappingProvider:mappingProvider];
}

- (id)performMapping
{
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // do the mapping
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:mimeType];
    id parsedData = [parser objectFromString:stringData error:nil];
    RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:provider];
    RKObjectMappingResult *result = [mapper performMapping];
    
    return [result asCollection];
}

@end
