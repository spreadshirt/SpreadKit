#import <GHUnitIOS/GHUnit.h>
#import "SPDesign.h"
#import "SPUser.h"
#import "SPResource.h"
#import "SPObjectMappingProvider.h"
#import <RestKit/RestKit.h>

@interface SPDesignMappingTests : GHTestCase
{
    SPObjectMappingProvider *testable;
}

@end

@implementation SPDesignMappingTests

- (void)setUpClass
{
    testable = [[SPObjectMappingProvider alloc] init];
}

// parse example json data
- (void)testDesignMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"design" ofType:@"json"];
    NSError *error = nil;
    NSString *designJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSData *data = [designJSON dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    
    RKObjectMapping *mapping = [testable objectMappingForClass:[SPDesign class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    NSDictionary *mappingsDictionary = @{ @"": mapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    [mapper execute:nil];
    id result = mapper.mappingResult.firstObject;
    
    SPDesign *design = (SPDesign *) result;
    
    GHAssertEqualStrings(design.name, @"herz", nil);
    GHAssertEqualStrings(design.description, @"Schmetterling, Freundin, Partner, Herz, Liebe, Zuneingung, Freundschaft, Antrag, Verliebt, Hochzeit, Gefühle, Engel, Teufel, Sex, Blume, Kleeblatt, Kreuz, Jesus, Pflanze, Sex, Ehe, Kleeblatt, Umriß, Kirche, Kreuz\r\n", nil);
    GHAssertEqualStrings(design.identifier, @"11359825", nil);
    GHAssertEqualStrings(design.user.identifier, @"2817135", nil);  
    GHAssertEquals([design.restrictions objectForKey:@"targetView"], [NSNumber numberWithInt:0], nil);
    GHAssertEqualStrings([design.size objectForKey:@"unit"], @"mm", nil);

}

// generate json data
- (void)testDesignSerialization
{
    
}

// test convienience method for getting upload url out of resources
- (void)testDesignUploadUrl
{
    SPDesign *design = [[SPDesign alloc] init];
    SPResource *uploadResource = [[SPResource alloc] init];
    uploadResource.type = @"montage";
    uploadResource.url = [NSURL URLWithString:@"http://image.spreadshirt.net/image-server/v1/designs/100001143"];
    design.resources = [NSArray arrayWithObject:uploadResource];
    
    GHAssertEqualStrings(uploadResource.url.absoluteString, design.uploadUrl.absoluteString, nil);
}

@end
