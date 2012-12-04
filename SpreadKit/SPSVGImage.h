//
//  SPSVGImage.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPSVG.h"
#import "SPEntity.h"

@interface SPSVGImage : SPSVG

@property NSNumber * width;
@property NSNumber * height;
@property NSString * designId;

@property UIImage * image;
@property (readonly) NSDictionary * svg;

@end
