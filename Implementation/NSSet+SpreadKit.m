//
//  NSSet+SpreadKit.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "NSSet+SpreadKit.h"
#import <objc/runtime.h>

static char const * const urlKey = "URL";

@implementation NSSet (SpreadKit)

- (void)setUrl:(NSURL *)url
{
    objc_setAssociatedObject(self, urlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)url
{
    return objc_getAssociatedObject(self, urlKey);
}

@end
