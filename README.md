# Whats The Weather
An app that displays the weather forcast in detail for the next 5 days. Forcasts can be searched by city name or coordinates(lat and long).

# Version
1.0.0

## Installation
### Flutter
Flutter needs to be set up on the device. Below are installation guides for different systems which will go through setting up the Flutter SDK, the emulator and other vital installations depending on the operation system at use.
* [Install flutter on Windows.](https://flutter.dev/docs/get-started/install/windows)
* [Install flutter on Mac.](https://flutter.dev/docs/get-started/install/macos)
* [Install flutter on Linux.](https://flutter.dev/docs/get-started/install/linux)
### VScode (optional)
Visual Studio code was used to develop the application. It provides a good platform to develop a flutter application with many useful extensions. It is an alternative to using Android studio (or X Code).
* [Install Vs Code for windows](https://code.visualstudio.com/download)

Useful extensions used were:
* Dart
* Dart(Syntax Highlighting Only)
* Flutter

Extensions can be added by pressing (Ctrl + Shift + X), while in the editor.

## Usage
### Snapshots

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/screenshots/1.png)

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/screenshots/2.png)

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/screenshots/3.png)

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/screenshots/4.png)

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/screenshots/5.png)

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/screenshots/6.png)

### Usage description (features)
The snapshots above display possible usage of the app. Below the possible usages are described in details.
#### Fetching weather forecast
It is possible to fetch a weather forecast for a city and for coordinates by inputting them in eather input field. If input is wrong, the location does not exist or the request fails for some reason, nothing will appear on the screen.
#### Forecast display
When the forecast is displayed on the screen the forecast for the current moment and today is displayed in the top of the list. Below is the forecast for the next four days.
#### Forecast details
It is possible to click on each of the four next days displayed to see a detailed forcast for that day. Details for the current day will always be displayed.
#### Caching functionality
Every time a new forecast is fetched the city or coordinates are cached. When the user restarts the application he will always see the newest forecast based on the latest search input. If the data has been stored for more than 12 hours the data will be deleted from the storage.
#### Refresh cache
Everytime there is something stored in the cache, the user can click on the "Refresh Cache" button on the buttom of the screen to empty the cache. If there is nothing in the cache, the button will be unclickable.


## Development
### Tech/framework used
* __Visual Studio Code__ was the editor used to develop the application. Debug mode was used so the application would reload every time changes were made.
* The __Android emulator__ (Nexus 5X API 29 x86) was used to display the application in the development process.
* The application was developed in __Windows__. The application should however display the app the same way as the Android emulator.
* __Flutter__ was used along with __Dart__ to write the code for the app. 

### API used
RapidApi was used to fetch the weather data (the current weather, weather for the next 5 days and further details for those 5 days).
* [Link to RapidAPI](https://rapidapi.com/community/api/open-weather-map/endpoints)
OpenWeather was used to fetch weather icon images to display in the forecast.
* [Link to OpenWeatherAPI](https://openweathermap.org/api)
 
### Additional packages used
Additional packages used in the development will be listed below with arguments why they were chosen to be used.
* __shared_preferences__
  * Provides a persistent storage of simple data to disk asynchronously. Since the data to store is simple, this package provides a simple and an efficient way to read and write the data. 

### Code guidelines
* __Consistency__ - Coding style should be consistent in the implementation.
  * *Strings* should be concatenated in the same way, using the + operator. They should always be in single quotes.
  * *Functions* should be declared and set up the same way. One line functions are allowed when code is only one line.
  * *If statements* can be in a single line if there is only one line. There should always be an else statement that follows an if statement.
  * *Comments* should be made if something is unclear or could possibly be unclear. 

### Git rules
There are two main branches, **_development_** and **_master_**. Guidelines are described below to specify each part in more details.
* **_Master branch_**
  * Only fully functional versions should be on the master branch. A pull request is made to the master branch from the development branch. 
* **_Development branch_**
  * The development takes place on this branch. Every time a new feature, fix or other is being worked on a branch is created based from the development branch. When development is completed on these branches a pull request is made to the development branch.
* **_Feat branches_**
  * When ever working on a new feature a branch should be checked out from the development branch with the name feat/nameOfNewFeature. 
* **_Fix branches_**
  * When ever working on a fix a branch should be checked out from the development branch with the name fix/nameOfFixing. 
* **_Commits_**
  * Commits should be made when ever a change has been made, it should be as small as possible.
* **_Commit messages_**
  * Commit messages are important. And all commit messages have to describe every thing that was changed. They should have a descriptive title and a text describing what was changed.
* **_Pull requests_**
  * Pull requests should be reviewed by another developer before merging the branch. 

### Process
These three stages were used to keep track of the development process where each task was written on a note and moved between stages until all notes eneded up in the "Done" stage.

![](https://github.com/thorirv15/WhatsTheWeather/blob/master/dev_process/1.jpg)
![](https://github.com/thorirv15/WhatsTheWeather/blob/master/dev_process/2.jpg)
![](https://github.com/thorirv15/WhatsTheWeather/blob/master/dev_process/3.jpg)

### Comments on future development
1. **Tests** should be added to the code base. Starting with unit tests, then integration tests and finally end to end tests. 

2. **Continuous Integration** should be used when the tests have been properly built. A solid pipeline should be constructed that runs the tests and possibly deploys the application.

3. **Bug fixes** Bugs need to be found and fixed.

4. **UI update** Styling of UI has to be developed further.

5. **More features** There are many possibilities of more features that can be added to the application. To name a few that would be good to have in the app:
   * Customized view.
     * Where user can control what details to see when looking at the forecast, since there are many things that can be displayed.
   * Units settings.
     * User should be able to set the units that are used when displaying the data (Fahrenheit, Kelvin or Celsius for example).
   * See forecast for more than one location at a time.
   * See forecast based on the location of the phone.
   * Receive notifications when there are alerting weather forecasts. 
   * Hear the weather forecast at set times.



## License
© Thorir Armann Valdimarsson




