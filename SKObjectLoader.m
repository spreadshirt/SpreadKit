//
//  SKObjectLoader.m
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectLoader.h"

@implementation SKObjectLoader

@synthesize delegate;

- (void)loadResourceFromPath:(NSString *)thePath mapWith:(RKObjectMapping *)theMapping
{
    NSString *fullPath = RKPathAppendQueryParams(thePath, [NSDictionary dictionaryWithKeysAndObjects:
                                      @"mediaType", @"json",
                                      nil]);
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:fullPath delegate:self block:^(RKObjectLoader * loader) {
        loader.objectMapping = theMapping;
    }];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (delegate != nil) {
        [delegate loader:self didLoadObjects:objects];
    }
}

@end
