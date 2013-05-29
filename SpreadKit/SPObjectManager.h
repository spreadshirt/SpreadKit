//
//  SPObjectManager.h
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "SPObjectCache.h"

@class SPList;

@interface SPObjectManager : NSObject

@property (nonatomic, readonly) NSString *apiKey;
@property (nonatomic, readonly) NSString *secret;
@property (nonatomic, readonly) int serverTimeOffset;
@property (nonatomic, strong) NSLocale *locale;

+ (SPObjectManager *)objectManagerWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;
- (id)initWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

// get objects
- (void)get:(id)objectStub params:(NSDictionary *)params completion:(void (^)(id loaded, NSError *error))completion;

// post objects
- (void)postObject:(id)theObject toURL:(NSURL *)theURL completion:(void (^)(id object, NSError *error))completion;

// put objects
- (void)putObject:(id)theObject completion:(void (^)(id object, NSError *error))completion;

// delete objects
- (void)deleteObject:(id)theObject completion:(void (^)(NSError *error))completion;

@end
