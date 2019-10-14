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
### VSCode (optional)
Visual Studio Code was used to develop the application. It provides a good platform to develop a flutter application with many useful extensions. It is an alternative to using Android studio (or XCode).
* [Install VSCode for windows](https://code.visualstudio.com/download)

Useful extensions used were:
* Dart
* Dart(Syntax Highlighting Only)
* Flutter

Extensions can be added by pressing (Ctrl + Shift + X), while in the editor.

## Running the application
The application was developed using __Windows__ in the __VSCode__ editor using the __Android emulator__ (Nexus 5X API 29 x86). The steps are according to that set up. The process should be simular using VSCode in Linux or Mac.
1. Start the emulator.
   1. Start Android Studio
   2. Go to Tools > AVD manager
   3. Press play to start up the emulator.
2. Open the project in VSCode.
   1. Go to Debug
   2. Press Start Debugging/use shortcut(F5)

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

### Wiki
More detailed documentation can be seen in the wiki part of the project where documents listed below can be found.
* Coding guidelines
* Git rules
* Development Process
* Comments on future development


## License
© Thorir Armann Valdimarsson




