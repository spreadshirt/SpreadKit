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

- (void)testDesignUpload
{
    UIImage *testImage = [UIImage imageNamed:@"testImage.jpg"];
    SKImageLoader *testable = [[SKImageLoader alloc] init];
    SKDesign *design = [[SKDesign alloc] init];
    SKResource *uploadResource = [[SKResource alloc] init];
    uploadResource.url = [NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/designs/100001143"];
    uploadResource.type = @"montage";
    design.resources = [NSArray arrayWithObject:uploadResource];
    [testable uploadImage:testImage forDesign:design completion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
}

@end
