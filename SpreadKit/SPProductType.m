//
//  ProductType.m
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SPProductType.h"
#import "SPView.h"

@implementation SPProductType

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
@synthesize defaultAppearance;

- (SPView *)defaultView
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

- (SPAppearance *)defaultAppearance
{
    NSString *defaultAppearanceIdentifier = [[defaultValues objectForKey:@"defaultAppearance"] objectForKey:@"id"];
    if (!defaultAppearance) {
        int defaultAppearanceIndex = [appearances indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj identifier] isEqualToString:defaultAppearanceIdentifier]) {
                return YES;
            } else {
                return NO;
            }
        }];
        if (defaultAppearanceIndex != NSNotFound) {
            defaultAppearance = [appearances objectAtIndex:defaultAppearanceIndex];
        }
    }
    return defaultAppearance;
}

- (SPPrintArea *) printAreaById: (NSString *) printAreaId {
    int printAreaIndex = [printAreas indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj identifier] isEqualToString:printAreaId]) {
            return YES;
        } else return NO;
    }];
    SPPrintArea *area = [printAreas objectAtIndex:printAreaIndex];
    return area;
    
}

- (SPPrintArea *)printAreaForView:(SPView *)view
{
    int printAreaIdx = [self.printAreas indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([[[obj defaultView] identifier] isEqualToString:view.identifier]);
    }];
    return [self.printAreas objectAtIndex:printAreaIdx];
}

@end
