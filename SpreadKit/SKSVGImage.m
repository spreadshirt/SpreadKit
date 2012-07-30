//
//  SKSVGImage.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import "SKSVGImage.h"
#import "SKViewSize.h"

@implementation SKSVGImage

- (SKViewSize *)size
{
    return [[SKViewSize alloc] initWithWidth:self.width andHeight:self.height];
}

@end
