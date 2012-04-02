//
//  SKImageLoader.m
//  SpreadKit
//
//  Created by Sebastian Marr on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKImageLoader.h"

@implementation SKImageLoader

- (void)loadImageFromUrl:(NSString *)url withWidth:(NSNumber *)width onSuccess:(void (^)(UIImage *))success onFailure:(void (^)(NSError *))failure
{
    // return if image width is not allowed
    if (![[[self class] allowedDimensions] containsObject:width]) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"The specified width is not allowed. Check [SKImageLoader allowedDimensions]." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"SpreadKit" code:50 userInfo:errorDetail];
        failure(error);
        return;
    }
    
    NSDictionary *queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%@", width], @"width",
                                 @"png", @"mediaType",
                                 nil];
    
    // add width parameters to url
    NSString *paramUrl = [url appendQueryParams:queryParams];
    NSURL *theUrl = [NSURL URLWithString:paramUrl];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:theUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connError) {
        if (data) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            success(image);
        } else {
            failure(connError);
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
    }
    return sAllowedDimensions;
}

@end
