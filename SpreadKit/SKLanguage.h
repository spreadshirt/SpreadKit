//
//  SKLanguage.h
//  SpreadKit
//
//  Created by Sebastian Marr on 16.07.12.
//
//

#import <Foundation/Foundation.h>

@interface SKLanguage : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * isoCode;
@property (nonatomic, strong) NSString * name;

@end