//
//  SKObjectLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol SKObjectLoaderDelegate <NSObject>

@optional
- (void)loader:(id)theLoader didLoadObjects:(NSArray *)theObjects;
- (void)loader:(id)theLoader didFailWithError:(NSError *)theError;

@end

@interface SKObjectLoader : NSObject <NSURLConnectionDelegate>

@property (weak) id<SKObjectLoaderDelegate> delegate;

// Loads an Object from a known resource Path with a given mapping
- (void)loadResourceFromUrl:(NSString *)thePath mapWith:(RKObjectMapping *)theMapping;

@end
