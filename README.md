# On-The-Map
A map-based app that shows information posted by other students at **Udacity**. The map contains pins that show the location where other students have reported studying. By tapping on the pin users can link to a URL. The user is able to add and update their own data by posting a string that can be reverse geocoded to a location, and a URL.

This was the *first* project in the *second* term of my iOS Nanodergree which has been submitted and passed. It gave me the  opportunity to post and retrieve data from a network resource using Apple’s networking framework, as well as authenticating users.

I implemented extra functionality which enables users to update their existing location by checking for an existing record in the database; also Facebook login functionlity.

## Pre-requisites
Facebook Frameworks:
- FacebookCore
- FBSDKCoreKit
- FBSDKLoginKit
- FBSDKShareKit

## Getting Started
Clone or download the project and run the On The Map.xcworkspace file; podfiles are included but if there are any issues the required pods are listed above. 

On initial launch the user is presented with an option to login with an email address (using Udacity account credentials) or Facebook. On Successful login pins can be viewed on a map or in a table list view. Tapping the pin icon (right of navigation bar) enables the user to add a pin or update an existing one. 

## Key learnings
- Accessing networked data using Apple’s URL loading framework
- Authenticating a user using over a network connection
- Creating user interfaces that are responsive, and communicate network activity
- Use Core Location and the MapKit framework for to display annotated pins on a map
- Facebook login process


