//
//  SPObjectMappingProvider.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPObjectMappingProvider.h"
#import "SPModel.h"

static SPObjectMappingProvider *sharedMappingProvider = nil;

@implementation SPObjectMappingProvider

- (id)init
{
    self = [super init];
    if (self){
        
        // often needed mappings
        NSDictionary *urlMapping = @{@"href": @"url"};
        NSDictionary *idMapping = @{@"id": @"identifier"};
        NSDictionary *idSerializationMapping = @{@"identifier": @"id"};
        NSDictionary *urlAndId = @{@"id": @"identifier", @"href": @"url"};
        
        
        // date formatting
        [RKObjectMapping addDefaultDateFormatterForString:@"dd-MMM-yyyy" inTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        RKObjectMapping *currencyMapping = [RKObjectMapping mappingForClass:[SPCurrency class]];
        [currencyMapping addAttributeMappingsFromDictionary:urlAndId];
        [currencyMapping addAttributeMappingsFromArray:@[@"plain", @"isoCode", @"symbol", @"decimalCount", @"pattern"]];
        
        RKObjectMapping *countryMapping = [RKObjectMapping mappingForClass:[SPCountry class]];
        [countryMapping addAttributeMappingsFromDictionary:urlAndId];
        [countryMapping addAttributeMappingsFromDictionary:@{@"length.unit": @"lengthUnit", @"length.unitFactor": @"lengthFactor"}];
        [countryMapping addAttributeMappingsFromArray:@[@"name", @"isoCode", @"thousandsSeparator", @"decimalPoint"]];
    
        RKObjectMapping *languageMapping = [RKObjectMapping mappingForClass:[SPLanguage class]];
        [languageMapping addAttributeMappingsFromDictionary:urlAndId];
        [languageMapping addAttributeMappingsFromArray:@[@"name", @"isoCode"]];
        
        RKObjectMapping *resourceMapping = [RKObjectMapping mappingForClass:[SPResource class]];
        [resourceMapping addAttributeMappingsFromDictionary:urlMapping];
        [resourceMapping addAttributeMappingsFromArray:@[@"mediaType", @"type"]];
        
        RKObjectMapping *appearanceMapping = [RKObjectMapping mappingForClass:[SPAppearance class]];
        [appearanceMapping addAttributeMappingsFromDictionary:idMapping];
        [appearanceMapping addAttributeMappingsFromArray:@[@"name"]];
        
        RKObjectMapping *printTypeMapping = [RKObjectMapping mappingForClass:[SPPrintType class]];
        [printTypeMapping addAttributeMappingsFromDictionary:urlAndId];
        [printTypeMapping addAttributeMappingsFromArray:@[@"weight", @"name", @"description", @"dpi", @"restrictions"]];
        
        RKObjectMapping *offsetMapping = [RKObjectMapping mappingForClass:[SPOffset class]];
        [offsetMapping addAttributeMappingsFromArray:@[@"unit", @"x", @"y"]];
        
        RKObjectMapping *configurationMapping = [RKObjectMapping mappingForClass:[SPProductConfiguration class]];
        [configurationMapping addAttributeMappingsFromDictionary:idMapping];
        [configurationMapping addAttributeMappingsFromArray:@[@"type", @"fontFamilies", @"restrictions"]];
        
        RKObjectMapping *viewMapping = [RKObjectMapping mappingForClass:[SPView class]];
        [viewMapping addAttributeMappingsFromDictionary:idMapping];
        [viewMapping addAttributeMappingsFromArray:@[@"name", @"perspective"]];
        
        RKObjectMapping *viewMapMapping = [RKObjectMapping mappingForClass:[SPViewMap class]];
        [viewMapMapping addAttributeMappingsFromDictionary:@{@"printArea.id": @"printAreaId"}];
        
        RKObjectMapping *colorMapping = [RKObjectMapping mappingForClass:[SPColor class]];
        [colorMapping addAttributeMappingsFromDictionary:@{@"value": @"representation", @"default": @"defaultColor", @"origin": @"originColor"}];
        [colorMapping addAttributeMappingsFromArray:@[@"index"]];
        
        RKObjectMapping *printAreaMapping = [RKObjectMapping mappingForClass:[SPPrintArea class]];
        [printAreaMapping addAttributeMappingsFromDictionary:idMapping];
        [printAreaMapping addAttributeMappingsFromArray:@[@"appearanceColorIndex", @"restrictions", @"boundary"]];
        
        RKObjectMapping *sizeMapping = [RKObjectMapping mappingForClass:[SPSize class]];
        [sizeMapping addAttributeMappingsFromDictionary:idMapping];
        [sizeMapping addAttributeMappingsFromArray:@[@"name", @"measures"]];
        
        RKObjectMapping *productTypeMapping = [RKObjectMapping mappingForClass:[SPProductType class]];
        [productTypeMapping addAttributeMappingsFromDictionary:urlAndId];
        [productTypeMapping addAttributeMappingsFromArray:@[@"weight", @"name", @"shortDescription", @"description", @"categoryName", @"brand", @"shippingFactor", @"sizeFitHint", @"defaultValues", @"washingInstructions", @"stockStates"]];
        
        RKObjectMapping *productTypeDepartmentMapping = [RKObjectMapping mappingForClass:[SPProductTypeDepartment class]];
        [productTypeDepartmentMapping addAttributeMappingsFromDictionary:urlAndId];
        [productTypeDepartmentMapping addAttributeMappingsFromArray:@[@"weight", @"name"]];
        
        RKObjectMapping *productTypeCategoryMapping = [RKObjectMapping mappingForClass:[SPProductTypeCategory class]];
        [productTypeCategoryMapping addAttributeMappingsFromDictionary:idMapping];
        [productTypeCategoryMapping addAttributeMappingsFromArray:@[@"name", @"nameSingular"]];
        
        RKObjectMapping *viewSizeMapping = [RKObjectMapping mappingForClass:[SPViewSize class]];
        [viewSizeMapping addAttributeMappingsFromArray:@[@"unit", @"width", @"height"]];
        
        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[SPProduct class]];
        [productMapping addAttributeMappingsFromDictionary:urlAndId];
        [productMapping addAttributeMappingsFromArray:@[@"name", @"weight", @"creator", @"restrictions"]];
        
        RKObjectMapping *articleMapping = [RKObjectMapping mappingForClass:[SPArticle class]];
        [articleMapping addAttributeMappingsFromDictionary:urlAndId];
        [articleMapping addAttributeMappingsFromArray:@[@"weight", @"name", @"description", @"articleCategories", @"created", @"modified"]];
        
        NSDateFormatter *articleDateFormatter = [NSDateFormatter new];
        articleDateFormatter.dateFormat = @"dd.MM.yyyy hh:mm:ss";
        articleDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        articleMapping.dateFormatters = [NSArray arrayWithObject:articleDateFormatter];
        
        RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[SPList class]];
        [listMapping addAttributeMappingsFromDictionary:urlMapping];
        [listMapping addAttributeMappingsFromArray:@[@"count", @"limit"]];
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[SPUser class]];
        [userMapping addAttributeMappingsFromDictionary:urlAndId];
        [userMapping addAttributeMappingsFromArray:@[@"name", @"description", @"memberSince"]];
        
        RKObjectMapping *shopMapping = [RKObjectMapping mappingForClass:[SPShop class]];
        [shopMapping addAttributeMappingsFromDictionary:urlAndId];
        [shopMapping addAttributeMappingsFromArray:@[@"name", @"passwordRestricted", @"hidden"]];
        
        RKObjectMapping *basketMapping = [RKObjectMapping mappingForClass:[SPBasket class]];
        [basketMapping addAttributeMappingsFromArray:@[@"token", @"links"]];
        
        RKObjectMapping *basketItemMapping = [RKObjectMapping mappingForClass:[SPBasketItem class]];
        [basketItemMapping addAttributeMappingsFromDictionary:idMapping];
        [basketItemMapping addAttributeMappingsFromArray:@[@"description", @"quantity", @"links", @"origin", @"element"]];
        
        RKObjectMapping *designMapping = [RKObjectMapping mappingForClass:[SPDesign class]];
        [designMapping addAttributeMappingsFromDictionary:urlAndId];
        [designMapping addAttributeMappingsFromArray:@[@"name", @"weight", @"description", @"sourceUrl", @"restrictions", @"created", @"modified", @"size"]];
        
        RKObjectMapping *priceMapping = [RKObjectMapping mappingForClass:[SPPrice class]];
        [priceMapping addAttributeMappingsFromArray:@[@"vatExcluded", @"vatIncluded", @"vat"]];
        
        RKObjectMapping *svgImageMapping = [RKObjectMapping mappingForClass:[SPSVGImage class]];
        [svgImageMapping addAttributeMappingsFromDictionary:@{
            @"image.designId": @"designId",
            @"image.width": @"width",
            @"image.height": @"height"
        }];
        
        RKObjectMapping *svgTextMapping = [RKObjectMapping mappingForClass:[SPSVGText class]];
        
        RKDynamicMapping *svgMapping = [RKDynamicMapping new];
        [svgMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
            NSDictionary *svg = (NSDictionary *)representation;
            
            if ([[svg allKeys] containsObject:@"image"]) {
                return svgImageMapping;
            } else if ([[svg allKeys] containsObject:@"text"]) {
                return svgTextMapping;
            }
            return nil;
        }];
        
        // relationships
        [countryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"currency" toKeyPath:@"currency" withMapping:currencyMapping]];

        
        [appearanceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [appearanceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printTypes" toKeyPath:@"printTypes" withMapping:printAreaMapping]];
        [appearanceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"colors" toKeyPath:@"colors" withMapping:colorMapping]];
        
        [colorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        
        [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
        [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productType" toKeyPath:@"productType" withMapping:productTypeMapping]];
        [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appearance" toKeyPath:@"appearance" withMapping:appearanceMapping]];
        [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"configurations" toKeyPath:@"configurations" withMapping:configurationMapping]];
        
        [printTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"size" toKeyPath:@"size" withMapping:sizeMapping]];
        [printTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price" toKeyPath:@"price" withMapping:priceMapping]];
        
        [printAreaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"defaultView" toKeyPath:@"defaultView" withMapping:viewMapping]];
        
        [productTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appearances" toKeyPath:@"appearances" withMapping:appearanceMapping]];
        [productTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sizes" toKeyPath:@"sizes" withMapping:sizeMapping]];
        [productTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [productTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printAreas" toKeyPath:@"printAreas" withMapping:printAreaMapping]];
        [productTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price" toKeyPath:@"price" withMapping:priceMapping]];
        [productTypeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"views" toKeyPath:@"views" withMapping:viewMapping]];
        
        [productTypeDepartmentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"categories" toKeyPath:@"categories" withMapping:productTypeCategoryMapping]];
        
        [productTypeCategoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productTypes" toKeyPath:@"productTypes" withMapping:productTypeMapping]];
        
        [articleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"shop" toKeyPath:@"shop" withMapping:shopMapping]];
        [articleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"product" toKeyPath:@"product" withMapping:productMapping]];
        [articleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [articleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price" toKeyPath:@"price" withMapping:priceMapping]];
        
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products" toKeyPath:@"products" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"designs" toKeyPath:@"designs" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"baskets" toKeyPath:@"baskets" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productTypes" toKeyPath:@"productTypes" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printTypes" toKeyPath:@"printTypes" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"shops" toKeyPath:@"shops" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"currencies" toKeyPath:@"currencies" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"languages" toKeyPath:@"languages" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"countries" toKeyPath:@"countries" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productTypeDepartments" toKeyPath:@"productTypeDepartments" withMapping:listMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"currency" toKeyPath:@"currency" withMapping:currencyMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"country" toKeyPath:@"country" withMapping:countryMapping]];
        [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"language" toKeyPath:@"language" withMapping:languageMapping]];
        
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products" toKeyPath:@"products" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"articles" toKeyPath:@"articles" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"designs" toKeyPath:@"designs" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"baskets" toKeyPath:@"baskets" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productTypes" toKeyPath:@"productTypes" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printTypes" toKeyPath:@"printTypes" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"currencies" toKeyPath:@"currencies" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"languages" toKeyPath:@"languages" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"countries" toKeyPath:@"countries" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productTypeDepartments" toKeyPath:@"productTypeDepartments" withMapping:listMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"currency" toKeyPath:@"currency" withMapping:currencyMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"country" toKeyPath:@"country" withMapping:countryMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"language" toKeyPath:@"language" withMapping:languageMapping]];
        [shopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];

        [basketMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"shop" toKeyPath:@"shop" withMapping:shopMapping]];
        [basketMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
        [basketMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"basketItems" toKeyPath:@"basketItems" withMapping:basketItemMapping]];
        
        [basketItemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price" toKeyPath:@"price" withMapping:priceMapping]];
        
        [designMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
        [designMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [designMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printTypes" toKeyPath:@"printTypes" withMapping:printTypeMapping]];
        [designMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"colors" toKeyPath:@"colors" withMapping:colorMapping]];
        [designMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price" toKeyPath:@"price" withMapping:priceMapping]];
        
        [configurationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printArea" toKeyPath:@"printArea" withMapping:printAreaMapping]];
        [configurationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printType" toKeyPath:@"printType" withMapping:printTypeMapping]];
        [configurationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"offset" toKeyPath:@"offset" withMapping:offsetMapping]];
        [configurationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"designs" toKeyPath:@"designs" withMapping:designMapping]];
        [configurationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [configurationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.svg" toKeyPath:@"content" withMapping:svgMapping]];
        
        [viewMapMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"offset" toKeyPath:@"offset" withMapping:offsetMapping]];
        
        [viewMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"size" toKeyPath:@"size" withMapping:viewSizeMapping]];
        [viewMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"resources" toKeyPath:@"resources" withMapping:resourceMapping]];
        [viewMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"viewMaps" toKeyPath:@"viewMaps" withMapping:viewMapMapping]];
        
        [priceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"currency" toKeyPath:@"currency" withMapping:currencyMapping]];
        
        // serialization mappings
        RKObjectMapping *designSerializationMapping = [designMapping inverseMapping];

        RKObjectMapping *basketSerializationMapping = [basketMapping inverseMapping];
        [basketSerializationMapping removePropertyMapping:[basketSerializationMapping mappingForSourceKeyPath:@"url"]];
        [basketSerializationMapping removePropertyMapping:[basketSerializationMapping mappingForSourceKeyPath:@"shop"]];
        
        RKObjectMapping *printTypeSerializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [printTypeSerializationMapping addAttributeMappingsFromDictionary:idSerializationMapping];
        
        RKObjectMapping *printAreaSerializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [printAreaSerializationMapping addAttributeMappingsFromDictionary:idSerializationMapping];
        
        RKObjectMapping *svgSerializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [svgSerializationMapping addAttributeMappingsFromArray:@[@"svg"]];
        
        RKObjectMapping *configurationSerializationMapping = [configurationMapping inverseMapping];
        [configurationSerializationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content" toKeyPath:@"content" withMapping:svgSerializationMapping]];
        [configurationSerializationMapping removePropertyMapping:[basketSerializationMapping mappingForSourceKeyPath:@"printArea"]];
        [configurationSerializationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printArea" toKeyPath:@"printArea" withMapping:printAreaSerializationMapping]];
        [configurationSerializationMapping removePropertyMapping:[basketSerializationMapping mappingForSourceKeyPath:@"printType"]];
        [configurationSerializationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"printType" toKeyPath:@"printType" withMapping:printTypeSerializationMapping]];
        
        RKObjectMapping *productTypeSerializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [productTypeSerializationMapping addAttributeMappingsFromDictionary:idSerializationMapping];
        
        RKObjectMapping *appearanceSerializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [appearanceSerializationMapping addAttributeMappingsFromDictionary:idSerializationMapping];
        
        RKObjectMapping *productSerializationMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [productSerializationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appearance" toKeyPath:@"appearance" withMapping:appearanceSerializationMapping]];
        [productSerializationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"productType" toKeyPath:@"productType" withMapping:productTypeSerializationMapping]];
        [productSerializationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"configurations" toKeyPath:@"configurations" withMapping:configurationSerializationMapping]];
        
        [self setSerializationMapping:basketSerializationMapping forClass:[SPBasket class]];
        [self setSerializationMapping:designSerializationMapping forClass:[SPDesign class]];
        [self setSerializationMapping:productSerializationMapping forClass:[SPProduct class]];
        
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
        [self setMapping:productTypeDepartmentMapping forKeyPath:@"productTypeDepartments"];
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

+ (SPObjectMappingProvider *)sharedMappingProvider
{
    if (sharedMappingProvider == nil) {
        sharedMappingProvider = (SPObjectMappingProvider* )[SPObjectMappingProvider mappingProvider];
    }
    return sharedMappingProvider;
}

@end
