//
//  SKImageLoader.m
//  SpreadKit
//
//  Created by Sebastian Marr on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKImageLoader.h"

@implementation SKImageLoader

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
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", widthToLoad], @"width",
                                 [NSString stringWithFormat:@"%d", heightToLoad], @"height",
                                 @"png", @"mediaType",
                                 nil];
    if (appearanceId) {
        [queryParams setObject:appearanceId forKey:@"appearanceId"];
    }
    
    NSString *paramUrl = [url.absoluteString appendQueryParams:queryParams];
    NSURL *theUrl = [NSURL URLWithString:paramUrl];
    
    // load the image
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:theUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connError) {
        if (data) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            image = [UIImage imageWithCGImage:image.CGImage scale:scaleFactor orientation:image.imageOrientation];
            completion(image, url, nil);
        } else {
            completion(nil, nil, connError);
        }
    }];
}

+ (NSArray *)allowedDimensions
{
    static NSArray *sAllowedDimensions;
    if (!sAllowedDimensions) {
        sAllowedDimensions = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:11],
                              [NSNumber numberWithInt:35],
                              [NSNumber numberWithInt:42],
                              [NSNumber numberWithInt:51],
                              [NSNumber numberWithInt:75],
                              [NSNumber numberWithInt:130],
                              [NSNumber numberWithInt:190],
                              [NSNumber numberWithInt:280],
                              [NSNumber numberWithInt:560],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:100],
                              [NSNumber numberWithInt:150],
                              [NSNumber numberWithInt:200],
                              [NSNumber numberWithInt:250],
                              [NSNumber numberWithInt:300],
                              [NSNumber numberWithInt:350],
                              [NSNumber numberWithInt:400],
                              [NSNumber numberWithInt:450],
                              [NSNumber numberWithInt:500],
                              [NSNumber numberWithInt:550],
                              [NSNumber numberWithInt:600],
                              [NSNumber numberWithInt:650],
                              [NSNumber numberWithInt:750],
                              [NSNumber numberWithInt:800],
                              [NSNumber numberWithInt:850],
                              [NSNumber numberWithInt:900],
                              [NSNumber numberWithInt:950],
                              [NSNumber numberWithInt:1000],
                              [NSNumber numberWithInt:1050],
                              [NSNumber numberWithInt:1100],
                              [NSNumber numberWithInt:1150],
                              [NSNumber numberWithInt:1200],
                              nil];
        NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        sAllowedDimensions = [sAllowedDimensions sortedArrayUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
    }
    return sAllowedDimensions;
}

@end
