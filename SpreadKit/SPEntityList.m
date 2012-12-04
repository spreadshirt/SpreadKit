//
//  SPEntityList.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPEntityList.h"

@implementation SPEntityList

@synthesize url;
@synthesize elements;
@synthesize limit;
@synthesize offset;
@synthesize count;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [elements countByEnumeratingWithState:state objects:buffer count:len];
}

@end
