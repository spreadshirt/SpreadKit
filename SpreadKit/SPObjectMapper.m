//
//  SPObjectMapper.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPObjectMapper.h"
#import "SPObjectMappingProvider.h"

@implementation SPObjectMapper
{
    Class class;
    NSString *mimeType;
    id destinationObject;
}

- (id)initWithMIMEType:(NSString *)theMimeType objectClass:(Class)theClass
{
    return [self initWithMIMEType:theMimeType objectClass:theClass andDestinationObject:nil];
}

- (id)initWithMIMEType:(NSString *)theMimeType objectClass:(Class)theClass andDestinationObject:(id)dest
{
    if (self = [super init]) {
        class = theClass;
        mimeType = theMimeType;
        destinationObject = dest;
    }
    return self;
}

+ (SPObjectMapper *)mapperWithMIMEType:(NSString *)mimeType objectClass:(Class)theClass
{
    return [[self alloc] initWithMIMEType:mimeType objectClass:theClass];
}

+ (SPObjectMapper *)mapperWithMIMEType:(NSString *)mimeType objectClass:(Class)theClass andDestinationObject:(id)dest
{
    return [[self alloc] initWithMIMEType:mimeType objectClass:theClass andDestinationObject:dest];
}

- (id)performMappingWithData:(NSData *)data
{
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // do the mapping
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:mimeType];
    id parsedData = [parser objectFromString:stringData error:nil];
    
    RKObjectMappingProvider *provider;
    
    if (class) {
        provider = [RKObjectMappingProvider objectMappingProvider];
        [provider setObjectMapping:[[SPObjectMappingProvider sharedMappingProvider] objectMappingForClass:class] forKeyPath:@""];
    } else {
        provider = [SPObjectMappingProvider sharedMappingProvider];
    }
    
    RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:provider];
    if (destinationObject) {
        mapper.targetObject = destinationObject;
    }
    RKObjectMappingResult *result = [mapper performMapping];
    
    return [result asCollection];
}

- (NSString *)serializeObject:(id)theObject
{
    RKObjectMapping *serializationMapping = [[SPObjectMappingProvider sharedMappingProvider] serializationMappingForClass:[theObject class]];
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
