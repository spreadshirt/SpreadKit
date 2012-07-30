//
//  SKViewSize.h
//  SpreadKit
//
//  Created by Sebastian Marr on 17.07.12.
//
//

#import <Foundation/Foundation.h>

@interface SKViewSize : NSObject

@property (nonatomic, strong) NSNumber * width;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSString * unit;

- (id)initWithWidth:(NSNumber *)width andHeight:(NSNumber *)height;

@end
