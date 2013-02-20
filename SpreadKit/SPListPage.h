//
//  SPListPage.h
//  SpreadKit
//
//  Created by Sebastian Marr on 13.02.13.
//  Copyright (c) 2013 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPList;

@interface SPListPage : NSObject

@property int page;
@property (nonatomic, weak) SPList * list;

@end
