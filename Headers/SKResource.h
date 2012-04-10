//
//  Resource.h
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKResource : NSObject

@property (nonatomic, strong) NSString * mediaType;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) UIImage * image;

@end
