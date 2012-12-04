//
//  SPEntityListTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 11.07.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import "SPEntityList.h"

@interface SPEntityListTests : GHTestCase

@end


@implementation SPEntityListTests

- (void)testFastEnumeration
{
    SPEntityList *list = [[SPEntityList alloc] init];
    list.elements = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
    for (NSString *s in list) {
        GHAssertNotNil(s, nil);
    }
}

@end
