//
//  SKProductConfiguration.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import "SKProductConfiguration.h"
#import "SKViewSize.h"
#import "SKSVG.h"
#import "SKSVGImage.h"

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
    return content.size;;
}

@end
