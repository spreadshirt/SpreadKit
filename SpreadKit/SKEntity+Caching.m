//
//  SKEntity+Caching.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.09.12.
//
//

#import "SKEntity+Caching.h"

#import "SKModel.h"

@implementation SKEntity (Caching)

- (NSString *)cachingIdentifier
{
    id selfTrick = self;
    if ([selfTrick respondsToSelector:@selector(url)]) {
        return [[selfTrick url] absoluteString];
    } else if ([selfTrick respondsToSelector:@selector(identifier)]){
        return [NSStringFromClass([self class]) stringByAppendingString:[selfTrick identifier]];
    } else {
        return nil;
    }
}

@end
