//
//  SKObjectLoader.m
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectLoader.h"
#import "RestKit/RKObjectMapper_Private.h"

@implementation SKObjectLoader

@synthesize delegate;

- (void)loadResourceFromUrl:(NSString *)theUrl mapWith:(RKObjectMapping *)theMapping
{
    NSString *configuredUrl = RKPathAppendQueryParams(theUrl, [NSDictionary dictionaryWithKeysAndObjects:
                                                               @"mediaType", @"json",
                                                               @"fullData", @"true",
                                                               nil]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:configuredUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // string from data
        NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // do the mapping
        NSString *MIMEType = response.MIMEType;
        id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
        id parsedData = [parser objectFromString:stringData error:nil];
        
        // temporary mapping provider
        RKObjectMappingProvider *prov = [[RKObjectMappingProvider alloc] init];
        if (theMapping.rootKeyPath) {
            [prov setMapping:theMapping forKeyPath:theMapping.rootKeyPath];
        } else {
            [prov setMapping:theMapping forKeyPath:@""];
        }
        
        RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:prov];
        RKObjectMappingResult *result = [mapper performMapping];
        
        [delegate loader:self didLoadObjects:[result asCollection]];
    }];
}

@end
