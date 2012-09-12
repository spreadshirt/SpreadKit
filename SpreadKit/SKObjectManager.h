//
//  SKObjectManager.h
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class SKEntityList;

@interface SKObjectManager : NSObject

@property (nonatomic, readonly) NSString *apiKey;
@property (nonatomic, readonly) NSString *secret;
@property (nonatomic, readonly) int serverTimeOffset;
@property (nonatomic, strong) NSLocale *locale;

+ (SKObjectManager *)objectManagerWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;
- (id)initWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

// get objects
- (void)get:(id)objectStub completion:(void (^)(id, NSError *))completion;

// post objects
- (void)postObject:(id)theObject toURL:(NSURL *)theURL completion:(void (^)(id object, NSError *error))completion;

// put objects
- (void)putObject:(id)theObject completion:(void (^)(id object, NSError *error))completion;

@end
