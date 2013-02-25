//
//  SPEntityList.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPList.h"

@implementation SPList
{
    int pages;
}

@synthesize url;
@synthesize elements;
@synthesize limit;
@synthesize count;

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
    if (pages == 0) {
        pages = ceil(self.count.floatValue / self.limit.floatValue);
    }
    
    return !(self.current.page == pages);
}

@end
