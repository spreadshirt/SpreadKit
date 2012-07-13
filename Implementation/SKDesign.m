//
//  SKDesign.m
//  SpreadKit
//
//  Created by Sebastian Marr on 12.07.12.
//
//

#import "SKDesign.h"
#import "SKResource.h"

@implementation SKDesign

@synthesize identifier;
@synthesize name;
@synthesize weight;
@synthesize description;
@synthesize sourceUrl;
@synthesize user;
@synthesize restrictions;
@synthesize size;
@synthesize colors;
@synthesize printTypes;
@synthesize price;
@synthesize resources;
@synthesize created;
@synthesize modified;
@synthesize url;

- (NSURL *)uploadUrl
{
    int index = [self.resources indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        SKResource *res = obj;
        if ([res.type isEqualToString:@"montage"]) {
            return YES;
            *stop = YES;
        } else return NO;
    }];
    return [[self.resources objectAtIndex:index] url];
}

@end