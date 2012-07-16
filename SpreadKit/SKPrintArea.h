//
//  SKPrintArea.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

@class SKView;

@interface SKPrintArea : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSNumber * appearanceColorIndex;
@property (nonatomic, strong) SKView * defaultView;
@property (nonatomic, strong) NSDictionary * restrictions;
@property (nonatomic, strong) NSDictionary * boundary;

@end
