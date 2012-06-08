//
//  SKAuthenticationProvider.m
//  SpreadKit
//
//  Created by Sebastian Marr on 04.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import "SKAuthenticationProvider.h"
#import <CommonCrypto/CommonDigest.h>
#import "SKClient.h"

@implementation SKAuthenticationProvider

+ (NSString *)authorizationHeaderFromApiKey:(NSString *)theApiKey andSecret:(NSString *)theSecret andURL:(NSString *)theURL andMethod:(NSString *)theMethod andSessionId:(NSString *)theSessionId
{
    int timeStamp = [[NSDate date] timeIntervalSince1970] - [[SKClient sharedClient] serverTimeOffset];
    return [self authorizationHeaderFromApiKey:theApiKey andSecret:theSecret andURL:theURL andMethod:theMethod andTimeStamp:[NSString stringWithFormat:@"%d", timeStamp] andSessionId:theSessionId];
}

+ (NSString *)authorizationHeaderFromApiKey:(NSString *)theApiKey andSecret:(NSString *)theSecret andURL:(NSString *)theURL andMethod:(NSString *)theMethod andTimeStamp:(NSString *)theTimestamp andSessionId:(NSString *)theSessionId
{
    NSString *returnHeader = @"SprdAuth";
    
    // include apiKey
    returnHeader = [returnHeader stringByAppendingFormat:@" apiKey=\"%@\"", theApiKey];
    
    //include data
    returnHeader = [returnHeader stringByAppendingFormat:@", data=\"%@ %@ %@\"", theMethod, theURL, theTimestamp];
    
    // calculate signature
    returnHeader = [returnHeader stringByAppendingFormat:@", sig=\"%@\"", [self signatureWithMethod:theMethod andURL:theURL andTime:theTimestamp andSecret:theSecret]];
    
    // if it exists, include the Session ID
    if (theSessionId) {
        returnHeader = [returnHeader stringByAppendingFormat:@", sessionId=\"%@\"", theSessionId];
    }
    
    return returnHeader;
}

+ (NSString *)signatureWithMethod:theMethod andURL:theURL andTime:theTimestamp andSecret:theSecret
{
    NSString *hashString = [NSString stringWithFormat:@"%@ %@ %@ %@", theMethod, theURL, theTimestamp, theSecret];
    return [self sha1:hashString];
}

+(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
