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
    [loader loadImageFromUrl:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1" withWidth:[NSNumber numberWithInt:11] onSuccess:^(UIImage *image) {
        GHAssertNotNil(image, @"image with correct dimensions should load");
    } onFailure:^ (NSError *error) {
        GHFail(@"There should be no error");
    }];
    
    [loader loadImageFromUrl:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1" withWidth:[NSNumber numberWithInt:12] onSuccess:^(UIImage *image) {
        GHFail(@"Should not succeed");
    } onFailure:^ (NSError *error) {
        GHAssertNotNil(error, @"error should be set on loading of disallowed dimensions");
        GHAssertEquals([error code], 50, @"Loading with incorrect dimensions should return the right error");
    }];
    
    [loader loadImageFromUrl:@"foo" withWidth:[NSNumber numberWithInt:11] onSuccess:^(UIImage *image) {
        GHFail(@"Should not succeed");
    } onFailure:^ (NSError *error) {
        GHAssertNotNil(error, @"error should be set on loading of wrong url");
        GHAssertEquals([error code], -1002, @"Loading with incorrect url should return the right error");
    }];
}

- (UIImage *)fakeGetImage:(NSURL *)theUrl error:(NSError **)error
{
    if ([theUrl isEqual:[NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1?width=11&mediaType=png"]]) {
        return [[UIImage alloc] init];
    } else if ([theUrl isEqual:[NSURL URLWithString:@"foo?width=11&mediaType=png"]]) {
        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:256 userInfo:nil];
    }
    return nil;
}

@end
