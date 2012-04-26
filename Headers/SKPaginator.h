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

- (void)loadNextPageAndOnSuccess:(void (^)(NSArray *pageElements))success onFailure:(void (^)(NSError *error))failure;


- (void)loadPreviousPageAndOnSuccess:(void (^)(NSArray *pageElements))success onFailure:(void (^)(NSError *error))failure;

- (id)initWithList:(SKEntityList *)list;

@end
