#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "SpreadKit.h"

@interface SPImageLoaderTests : GHAsyncTestCase
{
    SPImageLoader *loader;
}
@end

@implementation SPImageLoaderTests

- (void)setUp
{
    loader = [[SPImageLoader alloc] init];
}

- (void)tearDown
{
    loader = nil;
}

- (void)testRetinaAwareLoading
{
    CGSize neededSizeInPoints = CGSizeMake(100.0, 50.0);
    
    __block UIImage *result;
    [self prepare];
    [loader loadImageFromUrl:[NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1"] withSize:neededSizeInPoints completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        result = image;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(result, @"Image should have been loaded");
    GHAssertEquals(neededSizeInPoints.width , result.size.width, @"Loaded Image should have the needed width");
    GHAssertEquals(result.scale, [[UIScreen mainScreen] scale], @"Loaded image should be scaled for the current screen");
}

@end
