//
//  SKImageLoader.m
//  SpreadKit
//
//  Created by Sebastian Marr on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Constants.h"
#import "SKImageLoader.h"
#import "SKURLConnection.h"
#import "SKDesign.h"
#import "UIImage+Orientation.h"

@implementation SKImageLoader
{
    NSString * _apiKey;
    NSString * _secret;
}

- (id)initWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    if (self = [super init])
    {
        _apiKey = apiKey;
        _secret = secret;
    }
    return self;
}

+ (SKImageLoader *)loaderWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret
{
    return [[self alloc] initWithApiKey:apiKey andSecret:secret];
}

- (void)loadImageFromUrl:(NSURL *)url withSize:(CGSize)size completion:(void (^)(UIImage *, NSURL *, NSError *))completion
{
    [self loadImageFromUrl:url withSize:size andAppearanceId:nil completion:completion];
}

- (void)loadImageFromUrl:(NSURL *)url withSize:(CGSize)size andAppearanceId:(NSString *)appearanceId completion:(void (^)(UIImage *, NSURL *, NSError *))completion
{
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    
    NSUInteger pixelWidth = scaleFactor * size.width;
    NSUInteger pixelHeight = scaleFactor * size.height;
    
    // get the next biggest allowed size to get from the api
    __block NSUInteger widthToLoad = 0;
    __block NSUInteger heightToLoad = 0;
    [[[self class] allowedDimensions] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj unsignedIntValue] >= pixelWidth && widthToLoad == 0) {
             widthToLoad = [obj unsignedIntValue];
        }
        if ([obj unsignedIntValue] >= pixelHeight && heightToLoad == 0) {
            heightToLoad = [obj unsignedIntValue];
        }
        if (widthToLoad != 0 && heightToLoad != 0) {
            *stop = YES;
        }
    }];
    
    // calculate query parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", widthToLoad], @"width",
                                 [NSString stringWithFormat:@"%d", heightToLoad], @"height",
                                 @"png", @"mediaType",
                                 nil];
    if (appearanceId) {
        [params setObject:appearanceId forKey:@"appearanceId"];
    }
    
    [SKURLConnection get:url params:params apiKey:_apiKey secret:_secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200 && data) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            image = [UIImage imageWithCGImage:image.CGImage scale:scaleFactor orientation:image.imageOrientation];
            completion(image, url, nil);
        } else {
            completion(nil, nil, error);
        }
    }];
}

- (void)uploadImage:(UIImage *)image forDesign:(SKDesign *)design completion:(void (^)(SKDesign *, NSError *))completion
{
    [self uploadImage:image withQuality:1.0 forDesign:design completion:completion];
}

- (void)uploadImage:(UIImage *)image withQuality:(float)quality forDesign:(SKDesign *)design completion:(void (^)(SKDesign *, NSError *))completion
{
    // rotate image correctly before serialization
    UIImage *rotatedImage = [image rotatedImageWithOrientation:image.imageOrientation];
    
    [SKURLConnection put:UIImageJPEGRepresentation(rotatedImage, quality) toURL:design.uploadUrl params:nil apiKey:_apiKey secret:_secret completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] != 200) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithKeysAndObjects:NSLocalizedDescriptionKey, [NSString stringWithFormat:@"The upload failed with HTTP Code %d", [httpResponse statusCode]], @"ResponseContentKey", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], nil];
            NSError *error = [NSError errorWithDomain:SKErrorDomain code:SKImageUploadFailedError userInfo:userInfo];
            completion (design, error);
        }
        
        completion(design, nil);
    }];
}

+ (NSArray *)allowedDimensions
{
    static NSArray *sAllowedDimensions;
    if (!sAllowedDimensions) {
        sAllowedDimensions = @[ @11, @35, @42, @51, @75, @130, @190, @280, @560, @50, @100, @150, @200, @250, @300, @350, @400, @450, @500, @550, @600, @650, @700, @750, @800, @850, @900, @950, @1000, @1050, @1100, @1150, @1200 ];
        NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        sAllowedDimensions = [sAllowedDimensions sortedArrayUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
    }
    return sAllowedDimensions;
}

@end
