//
//  SKViewSize.m
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import "SKViewSize.h"

@implementation SKViewSize

@synthesize height, unit, width;

- (id)initWithWidth:(NSNumber *)theWidth andHeight:(NSNumber *)theHeight
{
    if (self = [super init]) {
        self.width = theWidth;
        self.height = theHeight;
        self.unit = @"mm";
    }
    return self;
}

@end
