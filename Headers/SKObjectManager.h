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

+ (SKObjectManager *)objectManagerWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;
- (id)initWithApiKey:(NSString *)apiKey andSecret:(NSString *)secret;

- (void)get:(id)objectStub completion:(void (^)(id, NSError *))completion;
- (void)getSingleEntityFromUrl:(NSURL *)url withParams:(NSDictionary *)params intoTargetObject:(id)target mapping:(RKObjectMapping *)mapping completion:(void (^)(NSArray *, NSError *))completion;
- (void)getEntityList:(SKEntityList *)list completion:(void (^)(SKEntityList *, NSError *))completion;
- (void)getEntityListFromUrl:(NSURL *)url withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion;

@end
