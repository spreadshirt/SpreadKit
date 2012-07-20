
//
//  SKView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import "SKView.h"
#import "SKViewMap.h"

@implementation SKView

@synthesize resources;
@synthesize identifier;
@synthesize name;
@synthesize perspective;
@synthesize size;
@synthesize viewMaps;

- (SKViewMap *) viewMapByPrintAreaId: (NSString *)printAreaId{
    int viewMapIndex = [viewMaps indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj printAreaId] isEqualToString:printAreaId]) {
            return YES;
        } else return NO;
    }];
    SKViewMap *map = [viewMaps objectAtIndex:viewMapIndex];
    return map;
}
@end
