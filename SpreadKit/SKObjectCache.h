//
//  SKObjectCache.h
//  SpreadKit
//
//  Created by Sebastian Marr on 20.09.12.
//
//

#import <Foundation/Foundation.h>
#import <MAObjCRuntime/MARTNSObject.h>
#include <MAObjCRuntime/RTProperty.h>
#include <MAObjCRuntime/RTMethod.h>

@interface SKObjectCache : NSObject

- (void)addObject:(id) object;
- (id)objectForUrl:(NSURL *)url;

@end
