//
//  SKSVGText.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.07.12.
//
//

#import <Foundation/Foundation.h>
#import "SKSVG.h"

@interface SKSVGText : SKSVG

@property NSString * fontStyle;
@property NSString * fontSize;
@property NSString * fontFamily;
@property NSString * textAnchor;
@property NSNumber * x;
@property NSNumber * y;
@property NSArray * lines;

@end
