//
//  ProductType.m
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKProductType.h"

@implementation SKProductType

@synthesize url;
@synthesize identifier;
@synthesize weight;
@synthesize name;
@synthesize shortDescription;
@synthesize description;
@synthesize categoryName;
@synthesize brand;
@synthesize shippingFactor;
@synthesize sizeFitHint;
@synthesize price;
@synthesize defaultValues;
@synthesize sizes;
@synthesize appearances;
@synthesize washingInstructions;
@synthesize views;
@synthesize printAreas;
@synthesize stockStates;
@synthesize resources;
@synthesize defaultView;

- (SKView *)defaultView
{
    NSString *defaultViewIdentifier = [[defaultValues objectForKey:@"defaultView"] objectForKey:@"id"];
    if (!defaultView) {
        int defaultViewIndex = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj identifier] isEqualToString:defaultViewIdentifier]) {
                return YES;
            } else {
                return NO;
            }
        }];
        if (defaultViewIndex != NSNotFound) {
            defaultView = [views objectAtIndex:defaultViewIndex];
        }
    }
    return defaultView;
}

@end
