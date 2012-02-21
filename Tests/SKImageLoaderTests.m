#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "SpreadKit.h"
#import "SKImageLoader+Private.h"

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
    id mock = [OCMockObject partialMockForObject:loader];
    [[[mock stub] andCall:@selector(fakeGetImage:error:) onObject:self] getImageFromUrl:[OCMArg any] error:[OCMArg setTo:nil]];
    
    NSError *error = nil;
    
    UIImage *image = [mock loadImageFromUrl:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1" withWidth:[NSNumber numberWithInt:11] error:&error];
    GHAssertNotNil(image, @"image with correct dimensions should load");
    GHAssertNil(error, @"error should be nil on correct load");
    
    NSError *error2 = nil;
    UIImage *image2 = [mock loadImageFromUrl:@"http://image.spreadshirt.net/image-server/v1/compositions/25386428/views/1" withWidth:[NSNumber numberWithInt:12] error:&error2];
    GHAssertNil(image2, @"image with disallowed dimensions should not load");
    GHAssertNotNil(error2, @"error should be set on loading of disallowed dimensions");
    GHAssertEquals([error2 code], 50, @"Loading with incorrect dimensions should return the right error");
    
    NSError *error3 = nil;
    UIImage *image3 = [mock loadImageFromUrl:@"foo" withWidth:[NSNumber numberWithInt:11] error:&error3];
    GHAssertNil(image3, @"Non-existant image should not load");
    GHAssertNotNil(error3, @"error should be set on loading of wrong url");
    GHAssertEquals([error3 code], 256, @"Loading with incorrect url should return the right error");
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
