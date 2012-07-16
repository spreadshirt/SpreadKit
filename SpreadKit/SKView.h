//
//  SKView.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKSize;

@interface SKView : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) SKSize * size;
@property (nonatomic, strong) NSString * perspective;
@property (nonatomic, strong) NSArray * resources;

@end
