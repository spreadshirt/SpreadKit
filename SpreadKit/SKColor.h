//
//  SKColor.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

@interface SKColor : SKEntity

@property (nonatomic, strong) NSNumber * index;
@property (nonatomic, strong) NSString * representation;
@property (nonatomic, strong) NSString * defaultColor;
@property (nonatomic, strong) NSString * originColor;
@property (nonatomic, strong) NSArray * resources;

@end
