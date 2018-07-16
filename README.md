<img src="https://flint.tools/assets/img/logo-dark-on-white.svg" width="230" alt="Flint framework logo">

# Flint Demo for iOS
[![Build Status](https://travis-ci.org/MontanaFlossCo/FlintDemo-iOS.svg?branch=master)](https://travis-ci.org/MontanaFlossCo/FlintDemo-iOS)

This is a sample project that uses [Flint](https://github.com/MontanaFlossCo/Flint) framework for Feature Driven Design.

This Master/Detail app provides simple "notes" gathering features with photo attachments. It demonstrates the use of Flint to:

* Define the Feature and Actions of an app
* Support conditional features (feature flagging, requiring purchase, platform versions etc.)
* Disabling features for which required system permissions are not authorized (e.g. Photos)
* Use Flint's Routes feature to implement custom URL schemes and deep linking
* Use Flint's Activities to automatically support Handoff, Spotlight search etc.
* Automatic analytics tracking
* Contextual logging
* Flint's "FlintUI" debug tools for browsing the feature hierarchy, Timeline, Focus logs and Action Stacks

## How to build and run

Currently only Carthage is supported, so you'll need that installed.

1. Check out the project
2. Run `carthage bootstrap --platform iOS --cache-builds`
3. Build and run the project in Xcode 9.2 or higher

## Using the app

The app lets you create "documents" that have a name and some body text and an optional photo attachment. You can edit them, remove them and share them.

Using the "Debug" option you can drill down into the Flint debug UIs to experiment with Flint and the insights it can give you.

### To browse the Features and Actions in the app

1. Go to the `Debug` option on the main screen 
2. Choose "Browse Features and Actions" 

Here you can the hierarchy of Features and their actions, the types they expect, their analytics IDs and so on.

### To view the Flint Timeline

1. Add and edit some documents. Swipe to delete some.
2. Now go to the `Debug` option on the main screen 
3. Choose "Timeline" 

Here you can see a Twitter-style feed of the actions you performed. You can tap for more details of what happened.

### To test URLs (Routes)

1. Create some documents with simple names like "test1", "test2", "test3" and so on and edit the text in some of them 
2. Switch away and launch Safari
3. Enter a URL into the address bar like `fdemo://open?name=test2` where you replace the `test2` part with the document you want to view, and press return/Go

Each time you do this, Flint should open each document you requested with the URL.

You should also find success with the custom "legacy" URL scheme that similates an app that used to have a different scheme, using `x-fd://open?name=test2` and so on. 

### To test Handoff

**NOTE**: The demo app does not support data sync (if anybody knows how we can make a sample app that works with sync without requiring any developer portal shenanigans to build and run, please let us know!).

So Handoff support is "faked" at the moment in that the demo app will send the name of the file to the receiving device as part of the Handoff data, and if the receiving device has a document of the same name it will open it – but the content will differ and the photo attachment will not be sent across either.

You will need to build the app for two devices. You cannot test Handoff with the simulator.

1. Build and run the app on two iOS devices that use the same iCloud account
2. Create a series of documents on one device, giving them useful text in the content so you can see which is which
3. Tap one of the documents to open it on the first device.
4. On the second device, make sure the app is not already running and go to the task switcher, dock or lock screen and look for the Handoff icon from "FlintDemo"
5. Tap on the icon / perform the required gesture and the app should open. 

### To test Spotlight

It's a bit of a hack but as a proof of concept, FlintDemo will register any document you open with Spotlight as part of the Handoff registration also.

To test it:

1. Create a series of documents on one device, giving them useful text in the content so you can see which is which, using some unique words
2. Go to the home screen, pull down for search, and type in some of those "unique words" or "Flint demo" to see the documents
3. Tap a document to open the app on that document
