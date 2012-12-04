//
//  SPEntity+Caching.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.09.12.
//
//

#import "SPEntity+Caching.h"

#import "SPModel.h"

@implementation SPEntity (Caching)

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
