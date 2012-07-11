//
//  SKPaginator.m
//  SpreadKit
//
//  Created by Sebastian Marr on 23.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKPaginator.h"
#import "SKEntityList.h"
#import "SKObjectLoader.h"

@implementation SKPaginator

@synthesize list;

- (id)initWithList:(SKEntityList *)theList
{
    if (self = [super init]) {
        self.list = theList;
    }
    return self;
}

+ (SKPaginator *)paginatorWithEntityList:(SKEntityList *)theList
{
    return [[[self class] alloc] initWithList:theList];
}

- (void)loadNextPageAndOnCompletion:(void (^)(NSArray *, NSError *))completion
{
    if (list) {
        NSNumber *newOffset = [NSNumber numberWithUnsignedInt:([self.list.offset unsignedIntValue] + [self.list.limit unsignedIntValue])];
        
        if ([newOffset integerValue] < [list.count integerValue])
        {
            self.list.offset = newOffset;
            [self loadPageAndOnCompletion:completion];
        }
    }
}

- (void)loadPreviousPageAndOnCompletion:(void (^)(NSArray *, NSError *))completion
{
    if (list) {
        NSNumber *newOffset = [NSNumber numberWithUnsignedInt:([self.list.offset unsignedIntValue] - [self.list.limit unsignedIntValue])];
        
        if ([newOffset integerValue] > 0)
        {
            self.list.offset = newOffset;
            [self loadNextPageAndOnCompletion:completion];
        }
    }
}

- (void)loadPageAndOnCompletion:(void (^)(NSArray *pageElems, NSError *error))completion
{
    SKObjectLoader *loader = [[SKObjectLoader alloc] init];
    [loader loadEntityList:list completion:^(SKEntityList *loaded, NSError *error) {
        completion([loaded.elements allObjects], nil);
    }];
}

@end
