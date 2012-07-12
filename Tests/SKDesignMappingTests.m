#import <GHUnitIOS/GHUnit.h>
#import "SKDesign.h"
#import "SKUser.h"
#import "SKObjectMappingProvider.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMapper_Private.h>

@interface SKDesignMappingTests : GHTestCase
{
    SKObjectMappingProvider *testable;
}

@end

@implementation SKDesignMappingTests

- (void)setUpClass
{
    testable = [SKObjectMappingProvider mappingProvider];
}

// parse example json data
- (void)testDesignMapping
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"design" ofType:@"json"];
    NSError *error = nil;
    NSString *designJSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString *MIMEType = @"application/json";
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:designJSON error:&error];
    
    RKObjectMapping *mapping = [testable objectMappingForClass:[SKDesign class]];
    GHAssertNotNil(mapping, @"mapping should be loaded correctly");
    
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:testable];
    
    RKObjectMappingResult* result = [mapper mapObject:parsedData atKeyPath:@"" usingMapping:mapping];
    
    SKDesign *design = (SKDesign *) result;
    
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
    
}

@end
