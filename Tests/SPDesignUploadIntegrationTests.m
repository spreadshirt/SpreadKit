//
//  DesignUploadIntegrationTest.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import <SpreadKit/SpreadKit.h>
#import <Nocilla/Nocilla.h>

@interface SPDesignUploadIntegrationTests : GHAsyncTestCase

@end


@implementation SPDesignUploadIntegrationTests

- (void)setUpClass
{
    [[LSNocilla sharedInstance] start];
}

- (void)tearDownClass
{
    [[LSNocilla sharedInstance] stop];
}

- (void)tearDown
{
    [[LSNocilla sharedInstance] clearStubs];
}

- (void)testDesignUpload
{
    // stubs
    stubRequest(@"POST", @"http://api.spreadshirt.net/api/v1/shops/41985/designs?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testDesignUpload1" ofType:@"txt"]]);
    stubRequest(@"GET", @"http://api.spreadshirt.net/api/v1/shops/41985/designs/u107788218?fullData=true&mediaType=json").
    andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testDesignUpload2" ofType:@"txt"]]);
    stubRequest(@"PUT", @"http://image.spreadshirt.net/image-server/v1/designs/107788218?").andReturn(200);
    
    
    NSString *apiKey = @"xxx";
    NSString *secret = @"xxx";
    
    // create and post a design
    SPDesign *design = [[SPDesign alloc] init];
    design.name = @"Super Cool Test Design";
    design.description = @"This is a Design created with SpreadKit";
    SPObjectManager *manager = [SPObjectManager objectManagerWithApiKey:apiKey andSecret:secret];
    [self prepare];
    [manager postObject:design toURL:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/41985/designs"] completion:^(id object, NSError *error) {
        if (error) {
            [self notify:kGHUnitWaitStatusFailure];
        } else {
            SPDesign *postedDesign = (SPDesign *)design;
            [manager get:postedDesign completion:^(id loaded, NSError *error) {
                if (error) {
                    [self notify:kGHUnitWaitStatusFailure];
                } else {
                    SPDesign *completeDesign = (SPDesign *)loaded;
                    // upload an image
                    UIImage *image = [UIImage imageNamed:@"testImage.jpg"];
                    
                    SPImageLoader *imageLoader = [SPImageLoader loaderWithApiKey:apiKey andSecret:secret];
                    
                    [imageLoader uploadImage:image forDesign:completeDesign completion:^(SPDesign *design, NSError *error) {
                        if (error) {
                            [self notify:kGHUnitWaitStatusFailure];
                        } else {
                            [self notify:kGHUnitWaitStatusSuccess];
                        }
                    }];
                }
            }];
        }
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:60];
    GHAssertNotNil([[design.resources objectAtIndex:0] url], nil);
}

@end
