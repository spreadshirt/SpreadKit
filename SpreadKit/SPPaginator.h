//
//  SPPaginator.h
//  SpreadKit
//
//  Created by Sebastian Marr on 23.04.12.
//  Copyright (c) 2012 sprd.net AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPEntityList;

@interface SPPaginator : NSObject

@property SPEntityList *list;

+ (SPPaginator *)paginatorWithEntityList:(SPEntityList *)list;

- (void)loadNextPageAndOnCompletion:(void (^)(NSArray *pageElements, NSError *error))completion;


- (void)loadPreviousPageAndOnCompletion:(void (^)(NSArray *pageElements, NSError *error))completion;

- (id)initWithList:(SPEntityList *)list;

@end
