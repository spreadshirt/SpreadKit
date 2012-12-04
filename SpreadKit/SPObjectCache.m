//
//  SPObjectCache.m
//  SpreadKit
//
//  Created by Sebastian Marr on 20.09.12.
//
//

#import "SPObjectCache.h"

#import "SPModel.h"
#import "SPEntity+Caching.h"

NSString* const SPObjectCacheObjectKey = @"SPObjectCacheObjectKey";
NSString* const SPObjectCacheKeyPathKey = @"SPObjectCacheKeyPathKey";

@interface SPObjectCache ()

@property NSMutableDictionary * entityReferences;
@property NSCache * cache;

@end

@implementation SPObjectCache

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
    if (![object cachingIdentifier]) {
        // not cachable, because no id;
        return;
    }
    
    id cached = [self.cache objectForKey:[object cachingIdentifier]];
    if (cached && ![self should:cached beReplacedBy:object]) {
        // cached object is better
        return;
    } else {
        [self.cache setObject:object forKey:[object cachingIdentifier]];
        [self pointReferencesToNewObject:object];
        for (RTProperty *property in [object class].rt_properties) {
            id propertyObject = [object valueForKey:[property name]];
            
            NSString *type = [[property.typeEncoding  stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([NSClassFromString(type) isSubclassOfClass:[SPEntity class]] && [propertyObject cachingIdentifier]) {
                
                if ([propertyObject respondsToSelector:@selector(url)])
                {
                    [self addReferenceForURL:[propertyObject url] byObject:object atKeyPath:property.name];
                }
                
                if (propertyObject)
                {
                    id cachedProperty = [self.cache objectForKey:[propertyObject cachingIdentifier]];
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
        [objectsAndKeyPaths addObject:@{SPObjectCacheObjectKey : object, SPObjectCacheKeyPathKey : keyPath}];
    }
}

- (void)pointReferencesToNewObject:(id)object
{
    NSMutableArray * objectsAndKeyPaths = [self.entityReferences objectForKey:[object cachingIdentifier]];
    for (NSDictionary * reference in objectsAndKeyPaths) {
        id referencingObject = reference[SPObjectCacheObjectKey];
        NSString * keyPath = reference[SPObjectCacheKeyPathKey];
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
