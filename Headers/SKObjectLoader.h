//
//  SKObjectLoader.h
//  SpreadKit
//
//  Created by Sebastian Marr on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SKObjectLoader : NSObject <NSURLConnectionDelegate>

- (void)loadSingleEntityFromUrl:(NSString *)url mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;
- (void)loadEntityListFromUrl:(NSString *)url mapping:(RKObjectMapping *)mapping onSucess:(void (^)(NSArray *objects))success onFailure:(void (^)(NSError *error))failure;

@end
