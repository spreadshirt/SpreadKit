//
//  SKView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKViewSize;

@interface SKView : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) SKViewSize * size;
@property (nonatomic, strong) NSString * perspective;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong) NSArray * viewMaps;

@end
