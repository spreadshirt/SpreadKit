# SpreadKit installation instructions for XCode 4

0. Check your Xcode build location
In the XCode Preferences under 'Locations', make sure that the 'Derived Data' Directory is set to 'Default'. Under 'Advanced...', the Build Location must be set to 'Unique'.

1. Check out SpreadKit from the repository
If you are collaborating with others, it might be usefull to choose a subdirectory of your project.

2. Add SpreadKit to your project
In Finder, find SpreadKit.xcodeproj and drag it into your Xcode workspace (you can choose any location you feel comfortable with).

3. Header search paths
In Xcode, choose your project file at the top and your application target. Under 'Build Settings', use the search to find 'Header Search Paths'. For both 'Header Search Paths' and 'User Header Search Paths', fill in '$(BUILT_PRODUCTS_DIR)'.

4. Linker flags
Still in 'Build Settings', find 'Other Linker Flags'. Enter '-ObjC -all_load'.

5. Add SpreadKit as a dependency
In 'Build Phases', add SpreadKit as a dependency of your project to ensure it always gets built before your app.

6. Link with frameworks
In the 'Link Binary With Libraries' section, add the following frameworks:
- libSpreadKit.a
- libRestKit.a
- CoreData.framework
- CFNetwork.framework
- Security.framework
- MobileCoreServices.framework
- SystemConfiguration.framework
- QuartzCore.framework
- libxml2.dylib

7. Import SpreadKit
Wherever you want to use SpreadKit, or in your Prefix Header, '#import <SpreadKit/SpreadKit.h>'. If everything builds fine after that, you're good to go!