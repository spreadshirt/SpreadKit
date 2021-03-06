//
//  SPImageLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class SPResource;
@class SPDesign;

@interface SPImageLoader : NSObject

+ (SPImageLoader *)loaderWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

- (id)initWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

- (void)loadImageFromUrl:(NSURL *)url withSize:(CGSize)size completion:(void (^)(UIImage *image, NSURL *imageUrl, NSError *error))completion;
- (void)loadImageFromUrl:(NSURL *)url withSize:(CGSize)size andAppearanceId:(NSString *)appearanceId completion:(void (^)(UIImage *image, NSURL *imageUrl, NSError *error))completion;

- (void)loadImageForResource:(SPResource *)resource withSize:(CGSize)size completion:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completion;
- (void)loadImageForResource:(SPResource *)resource withSize:(CGSize)size andAppearanceId:(NSString *)appearanceId completion:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completion;

// uploads a design image using maximum quality
- (void)uploadImage:(UIImage *)image forDesign:(SPDesign *)design completion:(void (^)(SPDesign *design, NSError *))completion;

// uploads a design image with possibilty to choose compression quality (between 0 and 1.0)
- (void)uploadImage:(UIImage *)image withQuality:(float)quality forDesign:(SPDesign *)design completion:(void (^)(SPDesign *, NSError *))completion;

@end
