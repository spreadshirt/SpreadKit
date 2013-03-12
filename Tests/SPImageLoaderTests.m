#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <Nocilla/Nocilla.h>

#import "SpreadKit.h"

@interface SPImageLoaderTests : GHAsyncTestCase
{
    SPImageLoader *loader;
}
@end

@implementation SPImageLoaderTests


- (void)setUpClass
{
    [[LSNocilla sharedInstance] start];
}

- (void)tearDownClass
{
    [[LSNocilla sharedInstance] stop];
}

- (void)setUp
{
    loader = [[SPImageLoader alloc] init];
}

- (void)tearDown
{
    [[LSNocilla sharedInstance] clearStubs];
    loader = nil;
}

- (void)testRetinaAwareLoading
{
    // stub request
    id fixturePath = [[NSBundle mainBundle] pathForResource:@"testRetinaAwareLoading" ofType:@"txt"];
    stubRequest(@"GET", @"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1?height=50&mediaType=png&width=100")
    .andReturnRawResponse([NSData dataWithContentsOfFile:fixturePath]);

    CGSize neededSizeInPoints = CGSizeMake(100.0, 50.0);
    
    __block UIImage *result;
    [self prepare];
    [loader loadImageFromUrl:[NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1"]
                    withSize:neededSizeInPoints
                  completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        result = image;
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    GHAssertNotNil(result, @"Image should have been loaded");
    GHAssertEquals(neededSizeInPoints.width, result.size.width, @"Loaded Image should have the needed width");
    GHAssertEquals(result.scale, [[UIScreen mainScreen] scale], @"Loaded image should be scaled for the current screen");
}

@end
