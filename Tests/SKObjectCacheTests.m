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

- (void)testObjectUpdatingReferences
{
    SKShop *shop = [[SKShop alloc] init];
    shop.url = [NSURL URLWithString:@"http://shop.url"];
    
    SKUser *user = [[SKUser alloc] init];
    user.url = [NSURL URLWithString:@"http://foo.user"];
    user.name = @"foo";
    
    shop.user = user;
    
    [self.cache addObject:shop];
    
    GHAssertEquals(user, [self.cache objectForUrl:user.url], nil);
    
    SKUser *updatedUser = [[SKUser alloc] init];
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
    SKShop *shop = [[SKShop alloc] init];
    shop.url = [NSURL URLWithString:@"http://foo.shop"];
    shop.identifier = @"foo";
    shop.name = @"foo";
    
    [self.cache addObject:shop];
    
    SKShop *shopStub = [[SKShop alloc] init];
    shopStub.url = [NSURL URLWithString:@"http://foo.shop"];
    
    
    SKArticle *article = [[SKArticle alloc] init];
    article.url = [NSURL URLWithString:@"http://article.url"];
    article.shop = shopStub;
    
    [self.cache addObject:article];
    
    GHAssertEquals(article.shop, shop, nil);
    
    SKUser *userStub = [[SKUser alloc] init];
    userStub.url = [NSURL URLWithString:@"http://foo.user"];
    userStub.identifier = @"foo";
    
    [self.cache addObject:userStub];
    
    SKUser *user = [[SKUser alloc] init];
    user.url = [NSURL URLWithString:@"http://foo.user"];
    user.identifier = @"foo";
    user.name = @"foo";
    
    SKDesign *design = [[SKDesign alloc] init];
    design.user = user;
    
    [self.cache addObject:design];
    
    GHAssertEquals(design.user, user, nil);
}

@end
