//
//  SKObjectMappingProvider.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectMappingProvider.h"
#import "SKModel.h"

static SKObjectMappingProvider *sharedMappingProvider = nil;

@implementation SKObjectMappingProvider

- (id)init
{
    self = [super init];
    if (self){
        
        // date formatting
        [RKObjectMapping addDefaultDateFormatterForString:@"dd-MMM-yyyy" inTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        RKObjectMapping *currencyMapping = [RKObjectMapping mappingForClass:[SKCurrency class]];
        [currencyMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [currencyMapping mapKeyPath:@"href" toAttribute:@"url"];
        [currencyMapping mapAttributes:@"plain", @"isoCode", @"symbol", @"decimalCount", @"pattern", nil];
        
        RKObjectMapping *countryMapping = [RKObjectMapping mappingForClass:[SKCountry class]];
        [countryMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [countryMapping mapKeyPath:@"href" toAttribute:@"url"];
        [countryMapping mapKeyPath:@"length.unit" toAttribute:@"lengthUnit"];
        [countryMapping mapKeyPath:@"length.unitFactor" toAttribute:@"lengthFactor"];
        [countryMapping mapAttributes:@"name", @"isoCode", @"thousandsSeparator", @"decimalPoint", nil];
        
        RKObjectMapping *languageMapping = [RKObjectMapping mappingForClass:[SKLanguage class]];
        [languageMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [languageMapping mapKeyPath:@"href" toAttribute:@"url"];
        [languageMapping mapAttributes:@"name", @"isoCode", nil];
        
        RKObjectMapping *resourceMapping = [RKObjectMapping mappingForClass:[SKResource class]];
        [resourceMapping mapAttributes:@"mediaType", @"type", nil];
        [resourceMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        RKObjectMapping *appearanceMapping = [RKObjectMapping mappingForClass:[SKAppearance class]];
        [appearanceMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [appearanceMapping mapAttributes:@"name", nil];
        
        RKObjectMapping *printTypeMapping = [RKObjectMapping mappingForClass:[SKPrintType class]];
        [printTypeMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [printTypeMapping mapKeyPath:@"href" toAttribute:@"url"];
        [printTypeMapping mapAttributes:@"weight", @"name", @"description", @"dpi", @"restrictions", nil];
        
        RKObjectMapping *offsetMapping = [RKObjectMapping mappingForClass:[SKOffset class]];
        [offsetMapping mapAttributes:@"unit", @"x", @"y", nil];
        
        RKObjectMapping *configurationMapping = [RKObjectMapping mappingForClass:[SKProductConfiguration class]];
        [configurationMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [configurationMapping mapAttributes:@"type", @"fontFamilies", @"restrictions", nil];
        
        RKObjectMapping *viewMapping = [RKObjectMapping mappingForClass:[SKView class]];
        [viewMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [viewMapping mapAttributes:@"name", @"perspective", nil];
        
        RKObjectMapping *viewMapMapping = [RKObjectMapping mappingForClass:[SKViewMap class]];
        [viewMapMapping mapKeyPath:@"printArea.id" toAttribute:@"printAreaId"];
        
        RKObjectMapping *colorMapping = [RKObjectMapping mappingForClass:[SKColor class]];
        [colorMapping mapKeyPath:@"index" toAttribute:@"index"];
        [colorMapping mapKeyPath:@"value" toAttribute:@"representation"];
        [colorMapping mapKeyPath:@"default" toAttribute:@"defaultColor"];
        [colorMapping mapKeyPath:@"origin" toAttribute:@"originColor"];
        
        RKObjectMapping *printAreaMapping = [RKObjectMapping mappingForClass:[SKPrintArea class]];
        [printAreaMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [printAreaMapping mapAttributes:@"appearanceColorIndex", @"restrictions", @"boundary", nil];
        
        RKObjectMapping *sizeMapping = [RKObjectMapping mappingForClass:[SKSize class]];
        [sizeMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [sizeMapping mapAttributes:@"name", @"measures", nil];
        
        RKObjectMapping *productTypeMapping = [RKObjectMapping mappingForClass:[SKProductType class]];
        [productTypeMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productTypeMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productTypeMapping mapAttributes:@"weight", @"name", @"shortDescription", @"description", @"categoryName", @"brand", @"shippingFactor", @"sizeFitHint", @"defaultValues", @"washingInstructions", @"stockStates", nil];
        
        RKObjectMapping *productTypeDepartmentMapping = [RKObjectMapping mappingForClass:[SKProductTypeDepartment class]];
        [productTypeDepartmentMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productTypeDepartmentMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productTypeMapping mapAttributes:@"weight", nil];
        
        RKObjectMapping *productTypeCategoryMapping = [RKObjectMapping mappingForClass:[SKProductTypeCategory class]];
        [productTypeCategoryMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [productTypeCategoryMapping mapAttributes:@"name", nil];
        
        RKObjectMapping *viewSizeMapping = [RKObjectMapping mappingForClass:[SKViewSize class]];
        [viewSizeMapping mapAttributes:@"unit", @"width", @"height", nil];
        
        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SKProduct class]];
        [productMapping mapAttributes:@"name", @"weight", @"creator", @"restrictions", nil];
        [productMapping mapKeyPath:@"href" toAttribute:@"url"];
        [productMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        
        RKObjectMapping *articleMapping = [RKObjectMapping mappingForClass:[SKArticle class]];
        [articleMapping mapAttributes:@"weight", @"name", @"description", @"articleCategories", @"created", @"modified", nil];
        [articleMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [articleMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        NSDateFormatter *articleDateFormatter = [NSDateFormatter new];
        articleDateFormatter.dateFormat = @"dd.MM.yyyy hh:mm:ss";
        articleDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        articleMapping.dateFormatters = [NSArray arrayWithObject:articleDateFormatter];
        
        RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[SKEntityList class]];
        [listMapping mapKeyPath:@"href" toAttribute:@"url"];
        [listMapping mapAttributes:@"count", @"offset", @"limit", nil];
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[SKUser class]];
        [userMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [userMapping mapKeyPath:@"href" toAttribute:@"url"];
        [userMapping mapAttributes:@"name", @"description", @"memberSince", nil];
        
        RKObjectMapping *shopMapping = [RKObjectMapping mappingForClass:[SKShop class]];
        [shopMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [shopMapping mapKeyPath:@"href" toAttribute:@"url"];
        [shopMapping mapAttributes:@"name", @"passwordRestricted", @"hidden", nil];
        
        RKObjectMapping *basketMapping = [RKObjectMapping mappingForClass:[SKBasket class]];
        [basketMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [basketMapping mapKeyPath:@"href" toAttribute:@"url"];
        [basketMapping mapAttributes:@"token", nil];
        
        RKObjectMapping *basketItemMapping = [RKObjectMapping mappingForClass:[SKBasketItem class]];
        [basketItemMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [basketItemMapping mapAttributes:@"description", @"quantity", @"links", @"origin", @"element", nil];
        
        RKObjectMapping *designMapping = [RKObjectMapping mappingForClass:[SKDesign class]];
        [designMapping mapAttributes:@"name", @"weight", @"description", @"sourceUrl", @"restrictions", @"created", @"modified", @"size", nil];
        [designMapping mapKeyPath:@"id" toAttribute:@"identifier"];
        [designMapping mapKeyPath:@"href" toAttribute:@"url"];
        
        RKObjectMapping *priceMapping = [RKObjectMapping mappingForClass:[SKPrice class]];
        [priceMapping mapAttributes:@"vatExcluded", @"vatIncluded", @"vat", nil];
        
        RKObjectMapping *svgImageMapping = [RKObjectMapping mappingForClass:[SKSVGImage class]];
        [svgImageMapping mapKeyPath:@"image.designId" toAttribute:@"designId"];
        [svgImageMapping mapKeyPath:@"image.width" toAttribute:@"width"];
        [svgImageMapping mapKeyPath:@"image.height" toAttribute:@"height"];
        
        
        RKObjectMapping *svgTextMapping = [RKObjectMapping mappingForClass:[SKSVGText class]];
        
        RKDynamicObjectMapping *svgMapping = [RKDynamicObjectMapping dynamicMapping];
        svgMapping.objectMappingForDataBlock = ^ RKObjectMapping* (id mappableData) {
            
            NSDictionary *svg = (NSDictionary *)mappableData;
            
            if ([[svg allKeys] containsObject:@"image"]) {
                return svgImageMapping;
            } else if ([[svg allKeys] containsObject:@"text"]) {
                return svgTextMapping;
            }
            return nil;
        };
        
        
        // relationships
        [countryMapping mapKeyPath:@"currency" toRelationship:@"currency" withMapping:currencyMapping];
        
        [appearanceMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [appearanceMapping mapKeyPath:@"printTypes" toRelationship:@"printTypes" withMapping:printTypeMapping];
        [appearanceMapping mapKeyPath:@"colors" toRelationship:@"colors" withMapping:colorMapping];
        
        [colorMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        
        [productMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [productMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [productMapping mapKeyPath:@"productType" toRelationship:@"productType" withMapping:productTypeMapping];
        [productMapping mapKeyPath:@"appearance" toRelationship:@"appearance" withMapping:appearanceMapping];
        [productMapping mapKeyPath:@"configurations" toRelationship:@"configurations" withMapping:configurationMapping];
        
        [printTypeMapping mapKeyPath:@"size" toRelationship:@"size" withMapping:sizeMapping];
        [printTypeMapping mapKeyPath:@"price" toRelationship:@"price" withMapping:priceMapping];
        
        [printAreaMapping mapKeyPath:@"defaultView" toRelationship:@"defaultView" withMapping:viewMapping];
        
        [productTypeMapping mapKeyPath:@"appearances" toRelationship:@"appearances" withMapping:appearanceMapping];
        [productTypeMapping mapKeyPath:@"sizes" toRelationship:@"sizes" withMapping:sizeMapping];
        [productTypeMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [productTypeMapping mapKeyPath:@"printAreas" toRelationship:@"printAreas" withMapping:printAreaMapping];
        [productTypeMapping mapKeyPath:@"price" toRelationship:@"price" withMapping:priceMapping];
        [productTypeMapping mapKeyPath:@"views" toRelationship:@"views" withMapping:viewMapping];
        
        [productTypeDepartmentMapping mapKeyPath:@"categories" toRelationship:@"categories" withMapping:productTypeCategoryMapping];
        
        [productTypeCategoryMapping mapKeyPath:@"productTypes" toRelationship:@"productTypes" withMapping:productTypeMapping];
        
        [articleMapping mapKeyPath:@"shop" toRelationship:@"shop" withMapping:shopMapping];
        [articleMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:productMapping];
        [articleMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [articleMapping mapKeyPath:@"price" toRelationship:@"price" withMapping:priceMapping];
        
        [userMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        [userMapping mapKeyPath:@"designs" toRelationship:@"designs" withMapping:listMapping];
        [userMapping mapKeyPath:@"baskets" toRelationship:@"baskets" withMapping:listMapping];
        [userMapping mapKeyPath:@"currency" toRelationship:@"currency" withMapping:currencyMapping];
        [userMapping mapKeyPath:@"country" toRelationship:@"country" withMapping:countryMapping];
        [userMapping mapKeyPath:@"language" toRelationship:@"language" withMapping:languageMapping];
        [userMapping mapKeyPath:@"productTypes" toRelationship:@"productTypes" withMapping:listMapping];
        [userMapping mapKeyPath:@"printTypes" toRelationship:@"printTypes" withMapping:listMapping];
        [userMapping mapKeyPath:@"shops" toRelationship:@"shops" withMapping:listMapping];
        [userMapping mapKeyPath:@"currencies" toRelationship:@"currencies" withMapping:listMapping];
        [userMapping mapKeyPath:@"languages" toRelationship:@"languages" withMapping:listMapping];
        [userMapping mapKeyPath:@"countries" toRelationship:@"countries" withMapping:listMapping];
        
        [shopMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:listMapping];
        [shopMapping mapKeyPath:@"articles" toRelationship:@"articles" withMapping:listMapping];
        [shopMapping mapKeyPath:@"productTypes" toRelationship:@"productTypes" withMapping:listMapping];
        [shopMapping mapKeyPath:@"designs" toRelationship:@"designs" withMapping:listMapping];
        [shopMapping mapKeyPath:@"baskets" toRelationship:@"baskets" withMapping:listMapping];
        [shopMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [shopMapping mapKeyPath:@"country" toRelationship:@"country" withMapping:countryMapping];
        [shopMapping mapKeyPath:@"language" toRelationship:@"language" withMapping:languageMapping];
        [shopMapping mapKeyPath:@"currency" toRelationship:@"currency" withMapping:currencyMapping];
        [shopMapping mapKeyPath:@"printTypes" toRelationship:@"printTypes" withMapping:listMapping];
        [shopMapping mapKeyPath:@"currencies" toRelationship:@"currencies" withMapping:listMapping];
        [shopMapping mapKeyPath:@"countries" toRelationship:@"countries" withMapping:listMapping];
        [shopMapping mapKeyPath:@"languages" toRelationship:@"languages" withMapping:listMapping];
        
        [basketMapping mapKeyPath:@"shop" toRelationship:@"shop" withMapping:shopMapping];
        [basketMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [basketMapping mapKeyPath:@"basketItems" toRelationship:@"basketItems" withMapping:basketItemMapping];
        
        [basketItemMapping mapKeyPath:@"price" toRelationship:@"price" withMapping:priceMapping];
        
        [designMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [designMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [designMapping mapKeyPath:@"printTypes" toRelationship:@"printTypes" withMapping:printTypeMapping];
        [designMapping mapKeyPath:@"colors" toRelationship:@"colors" withMapping:colorMapping];
        [designMapping mapKeyPath:@"price" toRelationship:@"price" withMapping:priceMapping];
        
        [configurationMapping mapKeyPath:@"printArea" toRelationship:@"printArea" withMapping:printAreaMapping];
        [configurationMapping mapKeyPath:@"printType" toRelationship:@"printType" withMapping:printTypeMapping];
        [configurationMapping mapKeyPath:@"offset" toRelationship:@"offset" withMapping:offsetMapping];
        [configurationMapping mapKeyPath:@"designs" toRelationship:@"designs" withMapping:designMapping];
        [configurationMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [configurationMapping mapKeyPath:@"content.svg" toRelationship:@"content" withMapping:svgMapping];
        
        [viewMapMapping mapKeyPath:@"offset" toRelationship:@"offset" withMapping:offsetMapping];
        
        [viewMapping mapKeyPath:@"size" toRelationship:@"size" withMapping:viewSizeMapping];
        [viewMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceMapping];
        [viewMapping mapKeyPath:@"viewMaps" toRelationship:@"viewMaps" withMapping:viewMapMapping];
        
        [priceMapping mapKeyPath:@"currency" toRelationship:@"currency" withMapping:currencyMapping];
        
        // serialization mappings
        
        RKObjectMapping *basketSerializationMapping = [basketMapping inverseMapping];
        RKObjectMapping *designSerializationMapping = [designMapping inverseMapping];
        RKObjectMapping *productSerializationMapping = [productMapping inverseMapping];
        RKObjectMapping *productTypeSerializationMapping = [productTypeMapping inverseMapping];
        RKObjectMapping *appearanceSerializationMapping = [appearanceMapping inverseMapping];
        RKObjectMapping *configurationSerializationMapping = [configurationMapping inverseMapping];
        
        [basketSerializationMapping removeMappingForKeyPath:@"url"];
        
        RKObjectMapping *printTypeSerializationMapping = [printTypeMapping inverseMapping];
        [printTypeSerializationMapping removeAllMappings];
        [printTypeSerializationMapping mapKeyPath:@"identifier" toAttribute:@"id"];
        
        
        RKObjectMapping *printAreaSerializationMapping = [printAreaMapping inverseMapping];
        [printAreaSerializationMapping removeAllMappings];
        [printAreaSerializationMapping mapKeyPath:@"identifier" toAttribute:@"id"];
        
        RKObjectMapping *svgSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
        [svgSerializationMapping mapKeyPath:@"svg" toAttribute:@"svg"];
        
        [configurationSerializationMapping mapKeyPath:@"content" toRelationship:@"content" withMapping:svgSerializationMapping];
        [configurationSerializationMapping removeMappingForKeyPath:@"printArea"];
        [configurationSerializationMapping mapKeyPath:@"printArea" toRelationship:@"printArea" withMapping:printAreaSerializationMapping];
        [configurationSerializationMapping removeMappingForKeyPath:@"printType"];
        [configurationSerializationMapping mapKeyPath:@"printType" toRelationship:@"printType" withMapping:printTypeSerializationMapping];
        
        [productTypeSerializationMapping removeAllMappings];
        [productTypeSerializationMapping mapKeyPath:@"identifier" toAttribute:@"id"];
        
        [appearanceSerializationMapping removeAllMappings];
        [appearanceSerializationMapping mapKeyPath:@"identifier" toAttribute:@"id"];
        
        [productSerializationMapping removeAllMappings];
        [productSerializationMapping mapKeyPath:@"appearance" toRelationship:@"appearance" withMapping:appearanceSerializationMapping];
        [productSerializationMapping mapKeyPath:@"productType" toRelationship:@"productType" withMapping:productTypeSerializationMapping];
        [productSerializationMapping mapKeyPath:@"configurations" toRelationship:@"configurations" withMapping:configurationSerializationMapping];
        
        [self setSerializationMapping:basketSerializationMapping forClass:[SKBasket class]];
        [self setSerializationMapping:designSerializationMapping forClass:[SKDesign class]];
        [self setSerializationMapping:productSerializationMapping forClass:[SKProduct class]];
        
        // mapping registrations
        [self addObjectMapping:userMapping];
        [self addObjectMapping:listMapping];
        [self addObjectMapping:appearanceMapping];
        [self addObjectMapping:productTypeMapping];
        [self addObjectMapping:productMapping];
        [self addObjectMapping:articleMapping];
        [self addObjectMapping:basketMapping];
        [self addObjectMapping:basketItemMapping];
        [self addObjectMapping:designMapping];
        [self addObjectMapping:printTypeMapping];
        [self addObjectMapping:printAreaMapping];
        [self addObjectMapping:offsetMapping];
        [self addObjectMapping:colorMapping];
        [self addObjectMapping:viewMapping];
        [self addObjectMapping:countryMapping];
        [self addObjectMapping:currencyMapping];
        [self addObjectMapping:languageMapping];
        [self addObjectMapping:viewMapMapping];
        [self addObjectMapping:svgImageMapping];
        [self addObjectMapping:svgTextMapping];
        [self addObjectMapping:productTypeCategoryMapping];
        [self addObjectMapping:productTypeDepartmentMapping];
        [self setMapping:articleMapping forKeyPath:@"articles"];
        [self setMapping:shopMapping forKeyPath:@"shop"];
        [self setMapping:userMapping forKeyPath:@"user"];
        [self setMapping:productMapping forKeyPath:@"products"];
        [self setMapping:productTypeMapping forKeyPath:@"productTypes"];
        [self setMapping:basketItemMapping forKeyPath:@"basketItems"];
        [self setMapping:designMapping forKeyPath:@"designs"];
        [self setMapping:basketMapping forKeyPath:@"baskets"];
        [self setMapping:printTypeMapping forKeyPath:@"printTypes"];
        [self setMapping:printAreaMapping forKeyPath:@"printAreas"];
        [self setMapping:languageMapping forKeyPath:@"languages"];
        [self setMapping:countryMapping forKeyPath:@"countries"];
        [self setMapping:currencyMapping forKeyPath:@"currencies"];
    }
    return self;
}

+ (SKObjectMappingProvider *)sharedMappingProvider
{
    if (sharedMappingProvider == nil) {
        sharedMappingProvider = (SKObjectMappingProvider* )[SKObjectMappingProvider mappingProvider];
    }
    return sharedMappingProvider;
}

@end
