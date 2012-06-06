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

- (void)testRetinaAwareLoading
{
    CGFloat neededSizeInPoints = 100.0;
    
    __block UIImage *result;
    [self prepare];
    [loader loadImageFromUrl:[NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1"] withWidth:neededSizeInPoints completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        result = image;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(result, @"Image should have been loaded");
    GHAssertEquals(neededSizeInPoints , result.size.width, @"Loaded Image should have the needed width");
    GHAssertEquals(result.scale, [[UIScreen mainScreen] scale], @"Loaded image should be scaled for the current screen");
}

@end
