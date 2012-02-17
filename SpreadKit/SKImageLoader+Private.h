//
//  SKImageLoader+Private.h
//  SpreadKit
//
//  Created by Sebastian Marr on 10.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SKImageLoader.h"

@interface SKImageLoader (Private)

- (UIImage *)getImageFromUrl:(NSURL *)url error:(NSError **)error;

@end