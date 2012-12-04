
//
//  SPView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import "SPView.h"
#import "SPViewMap.h"

@implementation SPView

@synthesize resources;
@synthesize identifier;
@synthesize name;
@synthesize perspective;
@synthesize size;
@synthesize viewMaps;

- (SPViewMap *) viewMapByPrintAreaId: (NSString *)printAreaId{
    int viewMapIndex = [viewMaps indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj printAreaId] isEqualToString:printAreaId]) {
            return YES;
        } else return NO;
    }];
    SPViewMap *map = [viewMaps objectAtIndex:viewMapIndex];
    return map;
}
@end
