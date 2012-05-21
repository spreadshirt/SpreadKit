#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "SpreadKit.h"

@interface SKImageLoaderTests : GHAsyncTestCase
{
    SKImageLoader *loader;
}
@end

@implementation SKImageLoaderTests

- (void)setUp
{
    loader = [[SKImageLoader alloc] init];
}

- (void)tearDown
{
    loader = nil;
}

- (void)testImageLoadingwithURL 
{
    __block UIImage *result1;
    [self prepare];
    [loader loadImageFromUrl:[NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1"] withWidth:[NSNumber numberWithInt:11] onSuccess:^(UIImage *image, NSURL *url) {
        result1 = image;
        [self notify:kGHUnitWaitStatusSuccess];
    } onFailure:^ (NSError *error) {
        GHFail(@"There should be no error");
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(result1, @"image with correct dimensions should load");
    
    __block NSError *result2;
    [self prepare];
    [loader loadImageFromUrl:[NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1"] withWidth:[NSNumber numberWithInt:12] onSuccess:^(UIImage *image, NSURL *url) {
        GHFail(@"Should not succeed");
    } onFailure:^ (NSError *error) {
        result2 = error;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(result2, @"error should be set on loading of disallowed dimensions");
    GHAssertEquals([result2 code], 50, @"Loading with incorrect dimensions should return the right error");

    __block NSError *result3;
    [self prepare];
    [loader loadImageFromUrl:[NSURL URLWithString:@"foo"] withWidth:[NSNumber numberWithInt:11] onSuccess:^(UIImage *image, NSURL *url) {
        GHFail(@"Should not succeed");
    } onFailure:^ (NSError *error) {
        result3 = error;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(result3, @"error should be set on loading of wrong url");
    GHAssertEquals([result3 code], -1002, @"Loading with incorrect url should return the right error");
}

@end
