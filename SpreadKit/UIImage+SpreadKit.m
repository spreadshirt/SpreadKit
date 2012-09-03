//
//  UIImage+SpreadKit.m
//  SpreadKit
//
//  Created by Sebastian Marr on 31.08.12.
//
//

#import "UIImage+SpreadKit.h"

@implementation UIImage (SpreadKit)

+ (UIImage *)spreadKitImageNamed:(NSString *)name {
    return [UIImage imageNamed:[NSString stringWithFormat:@"SpreadKitResources.bundle/%@", name]];
}

@end
