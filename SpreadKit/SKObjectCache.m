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
    if ([object respondsToSelector:@selector(url)])
    {
        [self.cache setObject:object forKey:[object url].absoluteString];
        [self pointReferencesToNewObject:object];
        // scan for attached entities
        for (RTProperty *property in [[object class] rt_properties]) {
            id propertyObject = [object valueForKey:[property name]];
            if ([[propertyObject class] isSubclassOfClass:[SKEntity class]]) {
                if ([propertyObject respondsToSelector:@selector(url)]) {
                    [self addReferenceForURL:[propertyObject url] byObject:object atKeyPath:property.name];
                }
                [self addObject:propertyObject];
            }
        }
    }
}

- (void)addReferenceForURL:(NSURL *)url byObject:(id)object atKeyPath:(NSString *)keyPath
{
    NSMutableArray * objectsAndKeyPaths = [self.entityReferences objectForKey:url.absoluteString];
    if (!objectsAndKeyPaths) {
        objectsAndKeyPaths = [NSMutableArray array];
        self.entityReferences[url.absoluteString] = objectsAndKeyPaths;
    }
    [objectsAndKeyPaths addObject:@{SKObjectCacheObjectKey : object, SKObjectCacheKeyPathKey : keyPath}];
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


@end
