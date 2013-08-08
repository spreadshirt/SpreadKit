//
//  SPObjectMapper.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPObjectMapper.h"
#import "SPObjectMappingProvider.h"
#import <SBJson/SBJson.h>

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
    // parsing
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:mimeType error:nil];
    
    NSDictionary *mappingsDictionary;
    
    if (class) {
        
        RKObjectMapping *mapping = [[SPObjectMappingProvider sharedMappingProvider] objectMappingForClass:class];
        mappingsDictionary = @{ @"": mapping };
    } else {
        mappingsDictionary = [[SPObjectMappingProvider sharedMappingProvider] mappingsDictionary];
    }
    
    
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
   
    if (destinationObject) {
        mapper.targetObject = destinationObject;
    }
    
    [mapper execute:nil];
    id result = mapper.mappingResult;
    
    return [result array];
}

- (NSString *)serializeObject:(id)theObject
{
    RKObjectMapping *serializationMapping = [[SPObjectMappingProvider sharedMappingProvider] serializationMappingForClass:[theObject class]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:serializationMapping objectClass:class rootKeyPath:nil method:RKRequestMethodAny];
    NSError *error = nil;
    NSDictionary *parameters = [RKObjectParameterization parametersWithObject:theObject requestDescriptor:requestDescriptor error:&error];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *serializedString = [writer stringWithObject:parameters];
    
    // object with no properties returns empty string
    if (mimeType == RKMIMETypeJSON && serializedString == nil) {
        serializedString = @"{}";
    }
    
    return serializedString;
}

@end
