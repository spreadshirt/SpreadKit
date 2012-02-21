//
//  Product.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SKResource;

@interface SKProduct : NSManagedObject

@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSSet *resources;
@end

@interface SKProduct (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(SKResource *)value;
- (void)removeResourcesObject:(SKResource *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

@end
