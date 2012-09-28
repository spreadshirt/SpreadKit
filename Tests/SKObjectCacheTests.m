//
//  SKObjectCacheTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.09.12.
//
//

#import <GHUnitIOS/GHUnit.h>

#import "SKObjectCache.h"
#import "SKModel.h"


@interface SKObjectCacheTests : GHTestCase

@property SKObjectCache *cache;

@end

@implementation SKObjectCacheTests

- (void)setUp
{
    self.cache = [[SKObjectCache alloc] init];
}

- (void)tearDown
{
    self.cache = nil;
}

- (void)testObjectCache
{
    SKShop *shop = [[SKShop alloc] init];
    
    SKUser *user = [[SKUser alloc] init];
    user.url = [NSURL URLWithString:@"http://foo.user"];
    user.name = @"foo";
    
    shop.user = user;
    
    [self.cache addObject:shop];
    
    GHAssertEquals(user, [self.cache objectForUrl:user.url], nil);
    
    SKUser *updatedUser = [[SKUser alloc] init];
    updatedUser.url = [NSURL URLWithString:@"http://foo.user"];
    updatedUser.name = @"bar";
    
    GHAssertEquals(shop.user, user, nil);
    
    [self.cache addObject:updatedUser];
    
    GHAssertEquals(shop.user, updatedUser, @"reference should have been updated");
    GHAssertEquals(updatedUser, [self.cache objectForUrl:updatedUser.url], nil);
}

@end
