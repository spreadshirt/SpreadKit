//
//  DesignUploadIntegrationTest.m
//  SpreadKit
//
//  Created by Sebastian Marr on 13.07.12.
//
//

#import <GHUnitIOS/GHUnit.h>
#import <SpreadKit/SpreadKit.h>

@interface DesignUploadIntegrationTests : GHAsyncTestCase

@end


@implementation DesignUploadIntegrationTests

- (void)testDesignUpload
{
    NSString *apiKey = @"xxx";
    NSString *secret = @"xxx";
    
    // create and post a design
    SKDesign *design = [[SKDesign alloc] init];
    design.name = @"Super Cool Test Design";
    design.description = @"This is a Design created with SpreadKit";
    SKObjectPoster *poster = [[SKObjectPoster alloc] init];
    [self prepare];
    [poster postObject:design toURL:[NSURL URLWithString:@"http://api.spreadshirt.net/api/v1/shops/41985/designs?mediaType=json"] apiKey:apiKey secret:secret mappingProvider:[SKObjectMappingProvider sharedMappingProvider] completion:^(id object, NSError *error) {
        if (error) {
            [self notify:kGHUnitWaitStatusFailure];
        } else {
            SKDesign *postedDesign = (SKDesign *)design;
            SKObjectLoader *loader = [SKObjectLoader loaderWithApiKey:apiKey andSecret:secret];
            [loader get:postedDesign completion:^(id loaded, NSError *error) {
                if (error) {
                    [self notify:kGHUnitWaitStatusFailure];
                } else {
                    SKDesign *completeDesign = (SKDesign *)loaded;
                    // upload an image
                    UIImage *image = [UIImage imageNamed:@"testImage.jpg"];
                    
                    SKImageLoader *imageLoader = [SKImageLoader loaderWithApiKey:apiKey andSecret:secret];
                    
                    [imageLoader uploadImage:image forDesign:completeDesign completion:^(SKDesign *design, NSError *error) {
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
