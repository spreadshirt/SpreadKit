# Introduction to SpreadKit

Welcome to SpreadKit. SpreadKit is an iOS Framework to interact with the [Spreadshirt](http://spreadshirt.net) API.

With SpreadKit, you can integrate catalog browsing, product creation and basket management into your iOS App. This guide will help you to get up and running with SpreadKit.

For useful information regarding the Spreadshirt API and a reference of all the resources, have a look at the [Spreadshirt Developer Network](https://developer.spreadshirt.net). There you can find out what is possible with the Spreadshirt API and get ideas for what you want to build using it.

### Prerequisites

SpreadKit was written exclusively for iOS, starting with Version 5.0. Currently, there are no plans for a Mac OS X framework.

In order to be able to, for example, create products and baskets, you need to apply for an API key at the [Spreadshirt Developer Network](https://developer.spreadshirt.net).

It is strongly encouraged that you use [CocoaPods](http://http://cocoapods.org) for managing your project's dependencies, mainly for two reasons: (1) SpreadKit installation will be much easier this way and (2) It is awesome :).

### Caveats

The following features have not been implemented yet, but are planned:

* support for the [Spreadshirt Order API](https://developer.spreadshirt.net/display/API/Order+Resources)
* support for text configurations on products
* support for supplying search queries on get requests
* [session](https://developer.spreadshirt.net/display/API/Security#Security-ExampleAPIKeySessionId%3A) support 

## Setup

The only supported way to install SpreadKit into your project is via CocoaPods, and it is quite simple. If you have not already, create a file named `Podfile` in your project root and include the following lines:

```ruby
platform :ios, '5.0'
pod 'SpreadKit', '~> 0.5'
```

Assuming you have installed CocoaPods (`sudo gem install cocoapods && pod setup`), you can run `pod install` and open the created `.xcworkspace` file with Xcode.

In your Code, wherever you need SpreadKit, just: 

```objc
#import <SpreadKit/SpreadKit.h>
```

(or do it in your prefix header) and you are ready to roll.

## Initialization

The Main entry point for SpreadKit is the `SPClient` class. It represents the main interface for all your calls to the Spreadshirt API. It can be either initialized scoped to a user or a shop, depending on your application. The initialization is done with:

```objc
[SPClient clientWithShopId:@"yourShopID"
                 andApiKey:@"yourAPIKey" 
                 andSecret:@"yourSecret"
               andPlatform:SPPlatformEU];
```
or:

```objc
[SPClient clientWithUserId:@"yourShopID"
                 andApiKey:@"yourAPIKey" 
                 andSecret:@"yourSecret"
               andPlatform:SPPlatformEU];
```

Please note that the platform parameter can only be either one of `SPPlatformEU` for the EU platform or `SPPlatformNA` for the NA Platform.

The first client to be initialized is later available via the `[SPClient sharedClient]` selector. In case you need to use more than one client at a time (e.g. one for EU and one for NA), just initialize them and store them in variables in your application. You can not use the `[SPClient sharedClient]` in that case.

## Basics

### Blocks

SpreadKit uses Objective-C Blocks nearly everywhere. They provide a convenient programming envirnoment when dealing with asynchronous calls, such as with web services like the Spreadshirt API. If you are not familiar with Blocks it is highly recommended you [read](http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html) [up](http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html) [on](http://ios-blog.co.uk/tutorials/programming-with-blocks-an-overview/) [them](http://mobile.tutsplus.com/tutorials/iphone/understanding-objective-c-blocks/).

Basically every call you make to the Spreadshirt API will include a block parameter named `completion`. This Block will have an `NSError` object and the data you requested as parameters. It is     up to you to handle potential erros and process the delivered data. To illustrate this programming model, have a look at the following code:

```objc
[client getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
    if (error) {
        // do some error handling
    } else {
        [controller shopLoaded:shop]
    }
}];
```

This gets the SPShop object associated with the client and notifies a view controller about the availability of that object (e.g. for displaying information of the shop or initiating further requests). There is no need for delegate methods, since the action on a completed request can be specified right at the location in the code where the request is made.

### Models

SpreadKit includes corresponding Objective-C classes for every resource type of the Spreadshirt API. You can check out the available resource types at the [Spreadshirt Developer Network](https://developer.spreadshirt.net/display/API/API+Resources).

### Main entry point

Your gate to the all the things you do with Spreadshirt resources is determined by how you initialize your `SPClient`. It can be either a shop or a user, depending on what you want to achieve. From there on, you will access all other resources based on this main one. For example, you retrieve the `SPShop` object of a shop-scoped client like this:

```objc
SPClient *client = [SPClient clientWithShopId:...];
[client getShopAndOnCompletion:^(SPShop *shop, NSError *error) {
    // do something with your retrieved shop object
}];
```

For a user-scoped client, this can be done in a similar fashion using the `getUserAndOnCompletion:completion` method.

### Browsing and getting objects

Once you got hold of your main object, you probably want to browse the API. The general way to do this is the `get` method of `SPClient`.

`get` is a wonderful and intuitive way to get resources from the Spreadshirt API. You can pass it an existing object stub to fill out the details, a list to get a number of objects in that list or just the type and ID of the object you want. In its `completion` block, `get` will return what you requested.

#### Lists

At the beginning, most of the attributes of your main object are of the class `SPList`. These are references to paginated lists of objects. Assuming you have an `SPShop` object named `shop`, you could access the first page of the shops products like this:

```objc
[client get:shop.products completion:^(id loaded, NSError *error) {
    NSArray *products = (NSArray *)loaded;
   // do something with the first page of products
}];
```

If you want the next page of the lists objects, just get it via the `more`property (this automatically points to the next page from the last one loaded):

```objc
[client get:shop.products.more completion:^(id loaded, NSError *error) {
    NSArray *productsPage2 = (NSArray *)loaded;
}];
```

You can access the `NSArray` the previously loaded objects at any time using the `elements` property of `SPList`:

```objc
NSArray *alreadyLoadedProducts = shop.products.elements;
```

To get an overview of the available pages, you can use the `pages` property of `SPList`. Please note that this will be available only after loading at least the first page.

You can check if there are more availabe pages to load at any time, using the `hasNextPage` property of `SPList`.

#### Single objects

Often times, the Spreadshirt API returns stub objects to keep responses small and fast. Stub objects are objects where not all properties are set yet. If you encounter a property of an object with the nil value, chances are pretty high it is just a stub and you can get more info using the `get` method of `SPClient`:

```objc
SPShop *shop;
// in this example, we fill out the stub objects of a shops user
[client get:shop.user completion^(id loaded, NSError *error) {
    SPUser *user = (SPUser *)loaded;
}];
```

If you know what you want, it is also possible to get something from the Spreadshirt API just with the type and ID of the object:

```objc
[client get:[SPProduct class] identifier:@"22169128" completion:^(id loaded, NSError *error) {
    SPProduct *product = (SPProduct *)loaded;
    // do something with the product
}];
```


#### Image resources

Most objects returned by the Spreadshirt API have a `resources` NSArray associated with them. This contains image resources of products, designs etc. to display within your app. You can browse this array to find suitable images.

The most important property of an `SPResource` is the `type` of the resource. You can find more information about the available resource types at the [SDN](https://developer.spreadshirt.net/display/API/Image+Resources).

Once you have picked the resource you wish to display, you can use the special `SPImageLoader` class to get an `UIImage` to display. Simply get yourself an instance

```objc
SPImageLoader *loader = [[SPImageLoader alloc] init]
```

and load the desired resource with a specified size (the size you want to display the image with)

```objc
[self loadImageForResource:resource withSize:size completion:^(UIImage *image, NSURL *imageURL, NSError *error) {
    // do something with your image 
}];
```

In the `completion` block, the URL from which the image is also returned, in case you want to use it (for example preventing switching images in  a `UITableView`).

The image is loaded automatically with the correct resolution for the device (retina or non-retina). Just specify the size needed in points, SpreadKit will figure it out.

Optionally, it is possible to specify an appearance used for loading the image resource. This is needed, when you get a product image for a product with customizable color (appearance). In that case, you can use the `loadImageForResource:withSize:andAppearanceId:completion:` method of `SPImageLoader`.

### Creating, updating and deleting Objects

Just like getting objects, you can also create, update and delete them. This is done via the `post`, `put` and `delete` methods of `SPClient`. Note that for most operations that change objects, you need a properly configured [API key](https://developer.spreadshirt.net).

For creating a new object, just use the `post` method, for example for a design:

```objc
SPDesign *design = [[SPDesign alloc] init];
design.name = @"Super Cool Test Design";
design.description = @"This is a Design created with SpreadKit";
[client post:design completion:^(id newObject, NSError *error){
    if (error) {
        // something went wrong, check the error
    }
    // newObject should be the object you just created
}];
```

Updating works the same way, just use the `put` method:

```objc
design.description = @"I totally updated that description!"
[client put:design completion:^(id updatedObject, NSError *error) {
   if (error) {
        // something went wrong, check the error
    }
    // updatedObject should be the object you just updated
}];
```

There a certain objects that can be deleted using the Spreadshirt API, for example Baskets or self-created products. This can be achieved using the `delete` method of `SPClient`.

```objc
SPDesign *design;
[client delete:design completion:^(NSError *error) {
    if (error) {
        // something went wrong during deletion, check error
    }
    // if object was deleted, error is nil
}];

```

## Baskets

To enable your users to buy products, it essential to be able to handle shopping baskets and lead them to checkout. This can be easily done with the `SPBasketManager`.

### Managing Basket Items

To start off with basket management, get yourself a shiny new instance of `SPBasketManager`:

```objc
SPBasketManager *basketManager = [SPBasketManager alloc] init];
```

For each item you want to add, call the `addToBasket:withSize:andAppearance` method of `SPBasketManager`. An item can be either an `SPArticle`or an `SPProduct`. To learn more about the difference between the two, check the [documentation](http://developer.spreadshirt.net/display/API/Product+Model).

`addToBasket:withSize:andAppearance` return an instance of `SPBasketItem`, that you can use to further specify the contents of you basket. In the following example, an `SPProduct` is added and then the quantity in the basket is changed:

```objc
SPProduct *product;
SPBasketManager *basketManager = [SPBasketManager alloc] init];
SPBasketItem *item = [basketManager addToBasket:product 
                                       withSize:[product.productType.sizes objectAtIndex:0] 
                                  andAppearance:product.appearance];
item.quantity = @2;
```
(This example uses the new Objective-C literals for NSNumber. If you don't know them, I highly recommend [to check them out](http://clang.llvm.org/docs/ObjectiveCLiterals.html)!)

You can check the items currently in your basket with `basketManager.items` and remove them using the `removeItem` method of `SPBasketManager`.

### Checkout

Currently, the Spreadshirt API only supports checkout via a webpage. To retrieve the checkout URL, you can use your `SPBasketManager`: 

```objc
[basketManagerm checkoutURLWithCompletion:^(NSURL *checkoutURL, NSError *error) {
    if (error) {
        // something is wrong with your basket, check the error messages
    } else {
        // for example, show a UIWebView for the checkoutURL
    }
}];
```

## Product Creation

Creating custom Products via the Spreadshirt API is [complex](http://developer.spreadshirt.net/display/API/Creating+Products+on+Spreadshirt+using+Spreadshirt+API+v1). To make it easier for you to create products, SpreadKit includes the `SPProductCreator`. Currently, this class supports creating a Product with one image configuration, positioned on the default print area of the selected product type.

Using the `SPProductCreator` is straight-forward:

```objc
SPProductCreator *creator = [[SPProductCreator alloc] init];
UIImage *image; // for example a picture taken with the camera
SPProductType *type; // a product type you have previosuly loaded from the API
SPProduct *product = [creator createProductWithProductType:type andImage:image];
```

After creation, you can still change the product to your liking. When you are done, upload it to Spreadshirt:

```objc
[creator uploadProduct:self.product completion:^(SPProduct *uploaded, NSError *error) {
    if (error) {
        // something is wrong woth your product, check the error
    }
    // use your product, e.g. put it in a basket! 
}];
```

For more complex products, you have to modify the Configurations of the product. Read up on it on the [SDN](http://developer.spreadshirt.net/display/API/Product+Model).

## Conclusion

This was a whirlwind tour of SpreadKit. You are welcome to explore the code for more things to do with it. For understanding the Spreadshirt domain model and what you can achieve with the Spreadshirt API, read the full documentation at the [Spreadshirt Developer Network](https://developer.spreadshirt.net).
