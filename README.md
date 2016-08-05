# POP-Nutshell
5th Udacity Project --Capstone
This app is the 5th project for the Udacity Nanodegree for iOS

This application utilizes the YouTube API to pull videos from the POP! Nutshell YouTube channel, displays and plays them.

Users can also share a video by swiping left on the video, displaying the share button. Video can be shared on any social media platform available on the device.

Included in the app is Cocoapods and the 3rd party library, Alamofire for network requests, SwiftyJSON for JSON handling, and ReachabilitySwift for checking internet connectivity. Please use the .xcworkspace file to run the app

The app also directs the user to the popnutshell.com articles section via a web request. There is also a "connect" section in this app that users can connect with the members of the popnutshell.com creative team via Twitter.

The Pop Nutshell app has a bug that has been discussed in the Apple forum https://forums.developer.apple.com/thread/4999
There is currently no fix or workaround for this bug. The only solution is to initially start the Pop Nutshell app, and restart it to load the tableview. Hopefully, Apple fixes this in the next iOS release.