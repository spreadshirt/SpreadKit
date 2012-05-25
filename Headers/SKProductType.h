//
//  ProductType.h
//  SpreadKit
//
//  Created by Sebastian Marr on 25.05.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKProductType : NSObject

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) NSDictionary *sizes;
@property (nonatomic, strong) NSSet *appearances;

@end
