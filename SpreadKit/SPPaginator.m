//
//  SPPaginator.m
//  SpreadKit
//
//  Created by Sebastian Marr on 23.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPPaginator.h"
#import "SPList.h"
#import "SPObjectManager.h"

@implementation SPPaginator

@synthesize list;

- (id)initWithList:(SPList *)theList
{
    if (self = [super init]) {
        self.list = theList;
    }
    return self;
}

+ (SPPaginator *)paginatorWithEntityList:(SPList *)theList
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
    SPObjectManager *manager = [[SPObjectManager alloc] init];
    [manager get:list completion:^(id loaded, NSError *error) {
        completion([loaded elements], error);
    }];
}

@end
