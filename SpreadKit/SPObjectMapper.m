//
//  SPObjectMapper.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPObjectMapper.h"

@implementation SPObjectMapper
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

+ (SPObjectMapper *)mapperWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider
{
    return [[self alloc] initWithMIMEType:mimeType mappingProvider:mappingProvider];
}

+ (SPObjectMapper *)mapperWithMIMEType:(NSString *)mimeType mappingProvider:(RKObjectMappingProvider *)mappingProvider andDestinationObject:(id)dest
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

- (NSString *)serializeObject:(id)theObject
{
    RKObjectMapping *serializationMapping = [provider serializationMappingForClass:[theObject class]];
    RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:theObject mapping:serializationMapping];
    NSError *error = nil;
    NSString* serializedString = [serializer serializedObjectForMIMEType:mimeType error:&error];
    if (error) {
        NSLog(@"something went wrong during serialization: %@", error);
    }
    
    // object with no properties returns empty string
    if (mimeType == RKMIMETypeJSON && serializedString == nil) {
        serializedString = @"{}";
    }
    
    return serializedString;
}

@end
