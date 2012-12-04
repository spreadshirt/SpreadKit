//
//  SPObjectCacheTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.09.12.
//
//

#import <GHUnitIOS/GHUnit.h>

#import "SPObjectCache.h"
#import "SPModel.h"


@interface SPObjectCacheTests : GHTestCase

@property SPObjectCache *cache;

@end

@implementation SPObjectCacheTests

- (void)setUp
{
    self.cache = [[SPObjectCache alloc] init];
}

- (void)tearDown
{
    self.cache = nil;
}

- (void)testObjectUpdatingReferences
{
    SPShop *shop = [[SPShop alloc] init];
    shop.url = [NSURL URLWithString:@"http://shop.url"];
    
    SPUser *user = [[SPUser alloc] init];
    user.url = [NSURL URLWithString:@"http://foo.user"];
    user.name = @"foo";
    
    shop.user = user;
    
    [self.cache addObject:shop];
    
    GHAssertEquals(user, [self.cache objectForUrl:user.url], nil);
    
    SPUser *updatedUser = [[SPUser alloc] init];
    updatedUser.url = [NSURL URLWithString:@"http://foo.user"];
    updatedUser.name = @"bar";
    updatedUser.memberSince = [NSDate date];
    
    GHAssertEquals(shop.user, user, nil);
    
    [self.cache addObject:updatedUser];
    
    GHAssertEquals(shop.user, updatedUser, @"reference should have been updated");
    GHAssertEquals(updatedUser, [self.cache objectForUrl:updatedUser.url], nil);
}

- (void)testObjectCacheSettingReferencesOnNewObjects
{
    SPShop *shop = [[SPShop alloc] init];
    shop.url = [NSURL URLWithString:@"http://foo.shop"];
    shop.identifier = @"foo";
    shop.name = @"foo";
    
    [self.cache addObject:shop];
    
    SPShop *shopStub = [[SPShop alloc] init];
    shopStub.url = [NSURL URLWithString:@"http://foo.shop"];
    
    
    SPArticle *article = [[SPArticle alloc] init];
    article.url = [NSURL URLWithString:@"http://article.url"];
    article.shop = shopStub;
    
    [self.cache addObject:article];
    
    GHAssertEquals(article.shop, shop, nil);
    
    SPUser *userStub = [[SPUser alloc] init];
    userStub.url = [NSURL URLWithString:@"http://foo.user"];
    userStub.identifier = @"foo";
    
    [self.cache addObject:userStub];
    
    SPUser *user = [[SPUser alloc] init];
    user.url = [NSURL URLWithString:@"http://foo.user"];
    user.identifier = @"foo";
    user.name = @"foo";
    
    SPDesign *design = [[SPDesign alloc] init];
    design.user = user;
    
    [self.cache addObject:design];
    
    GHAssertEquals(design.user, user, nil);
}

@end
