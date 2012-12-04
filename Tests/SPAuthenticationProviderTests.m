//
//  SPAuthenticationProviderTests.m
//  SpreadKit
//
//  Created by Sebastian Marr on 10.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SPAuthenticationProvider.h"

@interface SPAuthenticationProviderTests : GHTestCase

@end

@implementation SPAuthenticationProviderTests

- (void)testAuthorizationHeader
{
    NSString *header = [SPAuthenticationProvider authorizationHeaderFromApiKey:@"123456789" 
                                                                     andSecret:@"987654321" 
                                                                        andURL:@"http://localhost:8080/api/v1/users/42/productPriceCalculator" 
                                                                     andMethod:@"POST"
                                                                  andTimeStamp:@"1240575575156" 
                                                                  andSessionId:nil];
    
    NSString *targetHeader = @"SprdAuth apiKey=\"123456789\", data=\"POST http://localhost:8080/api/v1/users/42/productPriceCalculator 1240575575156\", sig=\"70aab75c0b6217c2aff1f896bd4081fe30920911\"";
    GHAssertEqualStrings(header, targetHeader, @"Authorization header without session id should be correct");
    
    header = [SPAuthenticationProvider authorizationHeaderFromApiKey:@"123456789" 
                                                           andSecret:@"987654321" 
                                                              andURL:@"http://localhost:8080/api/v1/users/42/productPriceCalculator" 
                                                           andMethod:@"POST"
                                                        andTimeStamp:@"1240575575156" 
                                                        andSessionId:@"123"];
    
    targetHeader = @"SprdAuth apiKey=\"123456789\", data=\"POST http://localhost:8080/api/v1/users/42/productPriceCalculator 1240575575156\", sig=\"70aab75c0b6217c2aff1f896bd4081fe30920911\", sessionId=\"123\"";
    GHAssertEqualStrings(header, targetHeader, @"Authorization header with session id should be correct");
}

@end
