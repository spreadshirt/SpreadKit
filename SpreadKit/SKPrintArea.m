//
//  SKPrintArea.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import "SKPrintArea.h"

@implementation SKPrintArea

@synthesize identifier;
@synthesize appearanceColorIndex;
@synthesize boundary;
@synthesize defaultView;
@synthesize restrictions;
@synthesize hardBoundary;

- (CGRect) hardBoundary {
    NSDictionary *rectDict = [[[[boundary objectForKey:@"hard"] objectForKey:@"content"]objectForKey:@"svg"]objectForKey:@"rect"];
    float x = [[rectDict objectForKey:@"x"] floatValue];
    float y = [[rectDict objectForKey:@"y"] floatValue];
    float width = [[rectDict objectForKey:@"width"] floatValue];
    float height = [[rectDict objectForKey:@"height"] floatValue];
    hardBoundary = CGRectMake(x, y, width, height);
    return hardBoundary;
}

@end
