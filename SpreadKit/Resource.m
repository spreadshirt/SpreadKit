//
//  Resource.m
//  SpreadKit
//
//  Created by Sebastian Marr on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Resource.h"


@implementation Resource

@dynamic mediaType;
@dynamic type;
@dynamic url;
@dynamic image;

@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return uiImage;
}

@end
