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


@class SKDesign;

@interface SKImageLoader : NSObject

+ (SKImageLoader *)loaderWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

- (id)initWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

- (void)loadImageFromUrl:(NSURL *)url withSize:(CGSize)size completion:(void (^)(UIImage *image, NSURL *imageUrl, NSError *error))completion;
- (void)loadImageFromUrl:(NSURL *)url withSize:(CGSize)size andAppearanceId:(NSString *)appearanceId completion:(void (^)(UIImage *image, NSURL *imageUrl, NSError *error))completion;
- (void)uploadImage:(UIImage *)image forDesign:(SKDesign *)design completion:(void (^)(SKDesign *design, NSError *))completion;

@end
