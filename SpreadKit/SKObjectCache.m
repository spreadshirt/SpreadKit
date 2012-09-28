//
//  SKObjectCache.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.09.12.
//
//

#import "SKObjectCache.h"

#import "SKModel.h"

NSString* const SKObjectCacheObjectKey = @"SKObjectCacheObjectKey";
NSString* const SKObjectCacheKeyPathKey = @"SKObjectCacheKeyPathKey";

@interface SKObjectCache ()

@property NSMutableDictionary * entityReferences;
@property NSCache * cache;

@end

@implementation SKObjectCache

- (id)init
{
    self = [super init];
    if (self) {
        self.entityReferences = [NSMutableDictionary dictionary];
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)addObject:(id)object
{
    if (!([object respondsToSelector:@selector(url)] && [object url])) {
        // not cachable, no unique identifier
        return;
    }
    
    id cached = [self.cache objectForKey:[object url].absoluteString];
    if (cached && ![self should:cached beReplacedBy:object]) {
        // cached object is better
        return;
    } else {
        [self.cache setObject:object forKey:[object url].absoluteString];
        [self pointReferencesToNewObject:object];
        for (RTProperty *property in [object class].rt_properties) {
            id propertyObject = [object valueForKey:[property name]];
            
            NSString *type = [[property.typeEncoding  stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([NSClassFromString(type) isSubclassOfClass:[SKEntity class]]) {
                
                [self addReferenceForURL:[propertyObject url] byObject:object atKeyPath:property.name];
                
                if (propertyObject)
                {
                    id cachedProperty = [self.cache objectForKey:[propertyObject url].absoluteString];
                    if (!cachedProperty || [self should:propertyObject beReplacedBy:cachedProperty]) {
                        [object setValue:cachedProperty forKey:property.name];
                    }
                    [self addObject:propertyObject];
                }
            }
        }
    }
}

- (void)addReferenceForURL:(NSURL *)url byObject:(id)object atKeyPath:(NSString *)keyPath
{
    if (url) {
        NSMutableArray * objectsAndKeyPaths = [self.entityReferences objectForKey:url.absoluteString];
        if (!objectsAndKeyPaths) {
            objectsAndKeyPaths = [NSMutableArray array];
            self.entityReferences[url.absoluteString] = objectsAndKeyPaths;
        }
        [objectsAndKeyPaths addObject:@{SKObjectCacheObjectKey : object, SKObjectCacheKeyPathKey : keyPath}];
    }
}

- (void)pointReferencesToNewObject:(id)object
{
    NSMutableArray * objectsAndKeyPaths = [self.entityReferences objectForKey:[object url].absoluteString];
    for (NSDictionary * reference in objectsAndKeyPaths) {
        id referencingObject = reference[SKObjectCacheObjectKey];
        NSString * keyPath = reference[SKObjectCacheKeyPathKey];
        [referencingObject setValue:object forKey:keyPath];
    }
}

- (id)objectForUrl:(NSURL *)url
{
    return [self.cache objectForKey:url.absoluteString];
}

- (BOOL)should:(id)objectA beReplacedBy:(id)objectB
{
    if ([objectA class] != [objectB class]) {
        [NSException raise:NSInternalInconsistencyException format:@"Trying to compare objects of different types"];
    }
    
    __block int objectANotNilProperties = 0;
    [[objectA class].rt_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RTProperty *property = (RTProperty *)obj;
        if ([objectA valueForKey:property.name])
        {
            objectANotNilProperties++;
        }
    }];
    
    __block int objectBNotNilProperties = 0;
    [[objectB class].rt_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RTProperty *property = (RTProperty *)obj;
        if ([objectB valueForKey:property.name])
        {
            objectBNotNilProperties++;
        }
    }];
    
    return objectBNotNilProperties > objectANotNilProperties;
}

@end
