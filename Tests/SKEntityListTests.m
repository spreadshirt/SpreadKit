//
//  SKEntityListTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 11.07.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import "SKEntityList.h"

@interface SKEntityListTests : GHTestCase

@end


@implementation SKEntityListTests

- (void)testFastEnumeration
{
    SKEntityList *list = [[SKEntityList alloc] init];
    list.elements = [NSSet setWithObjects:@"foo", @"bar", @"baz", nil];
    for (NSString *s in list) {
        GHAssertNotNil(s, nil);
    }
}

@end
