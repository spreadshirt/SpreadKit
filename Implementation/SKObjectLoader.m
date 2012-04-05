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

- (void)loadSingleEntityFromUrl:(NSString *)url mapping:(RKObjectMapping *)mapping
{
    // temporary mapping provider without root element
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:@""];
    [self loadResourceFromUrl:url mappingProvdider:prov];
}

- (void)loadEntityListFromUrl:(NSString *)url mapping:(RKObjectMapping *)mapping
{
    // temporary mapping provider with root element
    RKObjectMappingProvider *prov = [RKObjectMappingProvider mappingProvider];
    [prov setMapping:mapping forKeyPath:mapping.rootKeyPath];
    [self loadResourceFromUrl:url mappingProvdider:prov];
}

- (void)loadResourceFromUrl:(NSString *)theUrl mappingProvdider:(RKObjectMappingProvider *)mappingProvider
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
        
        RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
        RKObjectMappingResult *result = [mapper performMapping];
        
        [delegate loader:self didLoadObjects:[result asCollection]];
    }];
}

@end
