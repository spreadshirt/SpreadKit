//
//  DesignUploadIntegrationTest.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import <SpreadKit/SpreadKit.h>

@interface SPDesignUploadIntegrationTests : GHAsyncTestCase

@end


@implementation SPDesignUploadIntegrationTests

- (void)testDesignUpload
{
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
