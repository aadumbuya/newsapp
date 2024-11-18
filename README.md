# newsapp
NewsApp Main Development Documentation

1. API Chosen and Its Purpose
The NewsApp uses an external API to select and display articles containing the latest breaking news. The newsmodel.dart contains the set of fields representing the News data and the API response to Dart classes mapping. The app fetches details such as:

Source
Author
Title
Description
URL
Image URL
Publication Date
Content

This allows the app to pull and display new content related to news hence giving the users a better browsing experience.


2. The Purpose of Designed Screens
Onboarding Screen:
File: onboarding.dart

Purpose: This brief tutorial mainly provides first timers making use of the app, the initial configuration of the app preference using shared_preference. It informs the users what is contained in it before actually exposing them to their area of interest.

Home Screen (News View):
File: newsview.dart
Purpose: The set of articles that is shown is the most relevant one, and the authors receive data for that from the API. Attachments are titles, description and images that users share with the post linked to it.

Features:
Responsive Design: Requires the aid of flutter_screenutil to change layouts on other screen sizes.
Connectivity Check: Closes connection and passes the connection to the internet_connection_checker so that proper API interaction may be made.

3. Problem Faced and Solutions
1 Challenge: Managing Connectivity Issues
Resolution: internet_connection_checker was integrated to alert the users of connection issues and effortlessly attempt API calls.

2 Challenge: The design approach used here means that the elements of a website can be rearranged depending with the screen size of the device accessing the site.
Resolution: Depended on flutter_screenutil to maintain consistent design as it is used on different sizes and resolutions of the screens.

3 Challenge: Dynamic Data Mapping
Resolution: Created the newsmodel.dart file which helps the program to organize responses into structurally meaningful data. This made the processing and management of data to be easy within the context of the app.

4 Challenge: Storing User Preferences
Resolution: Added shared_preferences for onboarding completion status and user settings storing.

4. Directory Structure

lib/constants: Use to store constants that can be used throughout the entire application like colors and image paths.
lib/models: Includes yet another model for API named newsmodel.dart.
lib/views: two houses onboarding.dart and newsview.dart which handles the whole UI and key knit functionalities.

This documentation is about NewsApp, focusing on the development process, the architecture of the application, and solutions to problems that were faced when considering the development of NewsApp. ​
