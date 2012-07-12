//
//  SKDesign.h
//  SpreadKit
//
//  Created by Sebastian Marr on 12.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKUser;
@class SKSize;

@interface SKDesign : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSURL * sourceUrl;
@property (nonatomic, strong) SKUser * user;
@property (nonatomic, strong) NSDictionary * restrictions;
@property (nonatomic, strong) SKSize * size;
@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, strong) NSArray * printTypes;
@property (nonatomic, strong) NSDictionary * price;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * modified;

@end
