//
//  Product.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resource;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSSet *resources;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(Resource *)value;
- (void)removeResourcesObject:(Resource *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

@end
