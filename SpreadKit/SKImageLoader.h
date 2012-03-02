//
//  SKImageLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface SKImageLoader : NSObject

- (UIImage *)loadImageFromUrl:(NSString *)url withWidth:(NSNumber *)width error:(NSError **)error;
+ (NSArray *)allowedDimensions;

@end
