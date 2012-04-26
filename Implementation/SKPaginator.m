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

- (void)loadNextPageAndOnSuccess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    if (list) {
        NSNumber *newOffset = [NSNumber numberWithUnsignedInt:([self.list.offset unsignedIntValue] + [self.list.limit unsignedIntValue])];
        
        if ([newOffset integerValue] < [list.count integerValue])
        {
            self.list.offset = newOffset;
            [self loadPageAndOnSuccess:success onFailure:failure];
        }
    }
}

- (void)loadPreviousPageAndOnSuccess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *))failure
{
    if (list) {
        NSNumber *newOffset = [NSNumber numberWithUnsignedInt:([self.list.offset unsignedIntValue] - [self.list.limit unsignedIntValue])];
        
        if ([newOffset integerValue] > 0)
        {
            self.list.offset = newOffset;
            [self loadPageAndOnSuccess:success onFailure:failure];
        }
    }
}

- (void)loadPageAndOnSuccess:(void (^)(NSArray *pageElems))success onFailure:(void (^)(NSError *))failure
{
    SKObjectLoader *loader = [[SKObjectLoader alloc] init];
    [loader loadEntityList:list onSuccess:success onFailure:failure];
}

@end
