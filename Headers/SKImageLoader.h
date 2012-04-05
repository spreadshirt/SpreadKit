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

- (void)loadImageFromUrl:(NSString *)url withWidth:(NSNumber *)width onSuccess:(void (^)(UIImage *image))successBlock onFailure:(void (^)(NSError *))failBlock;

+ (NSArray *)allowedDimensions;

@end
