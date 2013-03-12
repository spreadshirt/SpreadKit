//
//  SPEntityListTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 11.07.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import "SPList.h"
#import "SPListPage.h"

@interface SPListTests : GHTestCase
{
    SPList *list;
}
@end


@implementation SPListTests

- (void)setUp
{
    list = [[SPList alloc] init];
    list.count = @500;
    list.limit = @50;
}

-(void)testFastEnumeration
{
    list.elements = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
    for (NSString *s in list) {
        GHAssertNotNil(s, nil);
    }
}

- (void)testInitialization {
    GHAssertEquals(list.current.page, 1, @"At the beginning, the page should be zero");
}

- (void)testMore {
    
    GHAssertEquals(list.current.page, 1, nil);
    
    SPListPage *more = list.more;
    
    GHAssertEqualObjects(more.list, list, @"list page should point to list");
    GHAssertEquals(more.page, 2, nil);
    GHAssertEquals(list.current, more, @"list current should point to new page");
}

- (void)testPaginationConvenience
{
    GHAssertTrue(list.hasNextPage, @"at the beginning, the list should have a next page");
    
    for (int i = 0; i < 9; i++) {
        GHAssertNotNil(list.more, @"list should advance to next page");
    };
    
    GHAssertFalse(list.hasNextPage, @"after all pages, there should be none left");
}

@end
