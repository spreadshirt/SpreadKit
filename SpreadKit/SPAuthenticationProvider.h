//
//  SPAuthenticationProvider.h
//  SpreadKit
//
//  Created by Sebastian Marr on 04.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAuthenticationProvider : NSObject

// calculates the SprdAuth Authorization Header, Session ID is optional
+ (NSString *)authorizationHeaderFromApiKey:(NSString *)theApiKey
                                  andSecret:(NSString *)theSecret 
                                     andURL:(NSString *)theURL 
                                  andMethod:(NSString *)theMethod
                               andTimeStamp:(NSString *)theTimestamp
                               andSessionId:(NSString *)theSessionId;

+ (NSString *)authorizationHeaderFromApiKey:(NSString *)theApiKey
                                  andSecret:(NSString *)theSecret 
                                     andURL:(NSString *)theURL 
                                  andMethod:(NSString *)theMethod
                               andSessionId:(NSString *)theSessionId;

@end
