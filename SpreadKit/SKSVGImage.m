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

- (NSDictionary *)svg
{
    NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:self.width, @"width", self.height, @"height", self.designId, @"designId", nil];
    NSDictionary *ret= [NSDictionary dictionaryWithObjectsAndKeys:imageDict, @"image", nil];
    return ret;
}

@end
