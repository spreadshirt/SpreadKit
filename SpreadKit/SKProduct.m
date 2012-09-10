//
//  Product.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKProduct.h"
#import "SKResource.h"
#import "SKUser.h"
#import "SKProductType.h"

@implementation SKProduct

@synthesize creator;
@synthesize name;
@synthesize identifier;
@synthesize resources;
@synthesize url;
@synthesize weight;
@synthesize user;
@synthesize restrictions;
@synthesize freeColorSelection;
@synthesize appearance;
@synthesize configurations;

- (void)setFreeColorSelection:(BOOL)freeColorSelection
{
    
}

- (BOOL)freeColorSelection
{
    return [[[self restrictions] objectForKey:@"freeColorSelection"] boolValue];
}

- (void)setProductType:(SKProductType *)productType
{
    _productType = productType;
    self.appearance = productType.defaultAppearance;
}

@end
