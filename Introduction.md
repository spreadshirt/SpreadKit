# Introduction to SpreadKit

Welcome to SpreadKit. SpreadKit is an iOS Framework to interact with the [Spreadshirt](http://spreadshirt.net) API.

With SpreadKit, you can integrate catalog browsing, product creation and basket management. into your iOS App. This guide will help you to get up and running with SpreadKit.

For useful information regarding the Spreadshirt API and a reference of all the resources, have a look at the [Spreadshirt Developer Network](https://developer.spreadshirt.net). There you can find out what is possible with the Spreadshirt API and get ideas for what you want to build using it.

## Prerequisites

SpreadKit was written exclusively for iOS, starting with Version 5.0. Currently, there are no plans for a Mac OS X framework.

In order to be able to, for example, create products and baskets, you need to apply for an API key at the [Spreadshirt Developer Network](https://developer.spreadshirt.net).

It is strongly encouraged that you use [CocoaPods](http://http://cocoapods.org) for managing your project's dependencies, mainly for two reasons: (1) SpreadKit installation will be much easier this way and (2) It is awesome :).

# Setup

The only supported way to install SpreadKit into your project is via CocoaPods, and it is quite simple. If you have not already, create a file named `Podfile` in your project root and include the following lines:
    platform :ios, '5.0'
    pod 'SpreadKit', '~> 1.0'

Assuming you have installed CocoaPods (`sudo gem install cocoapods`), you can run:
    pod install
and open the created `.xcworkspace` file with Xcode.

In your Code, wherever you need SpreadKit, just:
    #import <SpreadKit/SpreadKit.h>
(or do it in your prefix header) and you are ready to roll.

# Initialization

The Main entry point for SpreadKit is the `SPClient` class. It represents the main interface for all your calls to the Spreadshirt API. It can be either initialized scoped to a user or a shop, depending on your application. The initialization is done with:
    [SPClient clientWithShopId:@"yourShopID"
                     andApiKey:@"yourAPIKey" 
                     andSecret:@"yourSecret"
                   andPlatform:SPPlatformEU];
or:
    [SPClient clientWithUserId:@"yourShopID"
                     andApiKey:@"yourAPIKey" 
                     andSecret:@"yourSecret"
                   andPlatform:SPPlatformEU];
Please note that the platform parameter can only be either one of `SPPlatformEU` for the EU platform or `SPPlatformNA` for the NA Platform.

The first client to be initialized is later available via the `[SPClient sharedClient]` selector. In case you need to use more than one client at a time (e.g. one for EU and one for NA), just initialize them and store them in variables in your application. You can not use the `[SPClient sharedClient]` in that case.

# Basics

## Blocks

SpreadKit uses Objective-C Blocks nearly everywhere. They provide a convenient programming envirnoment when dealing with asynchronous calls, such as with web services like the Spreadshirt API. If you are not familiar with Blocks it is highly recommended you [read](http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html) [up](http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html) [on](http://ios-blog.co.uk/tutorials/programming-with-blocks-an-overview/) [them](http://mobile.tutsplus.com/tutorials/iphone/understanding-objective-c-blocks/).

Basically every call you make to the Spreadshirt API will include a block parameter named `completion`. This Block will have an `NSError` object and the data you requested as parameters. It is the up to you to handle potential erros and process the delivered data. To illustrate this programming model, have a look at the following code:

    [client getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
			if (error) {
				// do some error handling
			} else {
				[controller shopLoaded:shop]
			}
    }];

This gets the SPShop object associated with the client and notifies a view controller about the availability of that object (e.g. for displaying information of the shop or initiating further requests). There is no need for delegate methods, since the action on a completed request can be specified right at the location in the code where the request is made.

## Models

SpreadKit includes corresponding Objective-C classes for every resource type of the Spreadshirt API. You can check out the available resource types at the [Spreadshirt Developer Network](https://developer.spreadshirt.net/display/API/API+Resources).

## Basic resource methods

# Image resources

# Baskets

# Product Creation