//
//  SKProductConfiguration.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import "SKProductConfiguration.h"
#import "SKViewSize.h"

@implementation SKProductConfiguration

@synthesize identifier;
@synthesize content;
@synthesize offset;
@synthesize printArea;
@synthesize printType;
@synthesize type;
@synthesize designs;
@synthesize fontFamilies;
@synthesize resources;
@synthesize restrictions;
@synthesize size;

- (SKViewSize *)size
{
    SKViewSize * retSize;
    if ([[[self.content objectForKey:@"svg"] allKeys]
        containsObject:@"image"]) {
        retSize = [[SKViewSize alloc] init];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        retSize.width = [formatter numberFromString:[[[self.content objectForKey:@"svg"] objectForKey:@"image"] objectForKey:@"width"]];
        retSize.height = [formatter numberFromString:[[[self.content objectForKey:@"svg"] objectForKey:@"image"] objectForKey:@"height"]];
    }
    return retSize;
}

@end
