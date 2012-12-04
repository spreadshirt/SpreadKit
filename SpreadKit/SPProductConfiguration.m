//
//  SPProductConfiguration.m
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import "SPProductConfiguration.h"
#import "SPViewSize.h"
#import "SPSVG.h"
#import "SPSVGImage.h"

@implementation SPProductConfiguration

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

- (SPViewSize *)size
{
    return content.size;;
}

@end
