//
//  SKPaginator.h
//  SpreadKit
//
//  Created by Sebastian Marr on 23.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKEntityList;

@interface SKPaginator : NSObject

@property SKEntityList *list;

+ (SKPaginator *)paginatorWithEntityList:(SKEntityList *)list;

- (void)loadNextPageAndOnCompletion:(void (^)(NSArray *pageElements, NSError *error))completion;


- (void)loadPreviousPageAndOnCompletion:(void (^)(NSArray *pageElements, NSError *error))completion;

- (id)initWithList:(SKEntityList *)list;

@end
