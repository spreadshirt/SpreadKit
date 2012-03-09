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

@interface SKObjectLoader : NSObject <RKObjectLoaderDelegate>

@property (weak) id delegate;

// Loads an Object from a known resource Path with a given mapping
- (void)loadResourceFromPath:(NSString *)thePath mapWith:(RKObjectMapping *)theMapping;

@end
