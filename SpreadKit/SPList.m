//
//  SPEntityList.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPList.h"

@implementation SPList

@synthesize url;
@synthesize elements;
@synthesize limit;
@synthesize count;
@synthesize pages;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [elements countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)init
{
    if (self = [super init]) {
        _current = [[SPListPage alloc] init];
        self.current.page = 1;
        self.current.list = self;
        self.elements = [NSArray array];
        pages = 0;
    }
    return self;
}

- (void)setCount:(NSNumber *)theCount
{
    count = theCount;
    pages = ceil(self.count.floatValue / self.limit.floatValue);
}

- (void)setLimit:(NSNumber *)theLimit
{
    limit = theLimit;
    pages = ceil(self.count.floatValue / self.limit.floatValue);
}

- (SPListPage *)more
{
    SPListPage *more = [[SPListPage alloc] init];
    more.list = self;
    more.page = self.current.page + 1;
    _current = more;
    return more;
}

- (BOOL)hasNextPage
{
    return !(self.current.page == pages);
}

@end
