//
//  Resource.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface ImageToDataTransformer : NSValueTransformer {
}
@end

@interface Resource : NSManagedObject

@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) UIImage * image;

@end
