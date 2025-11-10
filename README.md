Nguyen Thi Hoai Ha -22IT073
# WeatherOneDay 🌤️

A beautiful **Flutter Weather App** that shows **current weather** for your location with a modern, sleek UI.  

## Features

- ✅ Fetch current weather from **OpenWeatherMap API**
- ✅ Display **temperature, humidity, wind speed, and pressure**
- ✅ Show **city name and weather description**
- ✅ **Dynamic gradient background** depending on weather
- ✅ **Glassmorphism card** with soft shadows and rounded corners
- ✅ Weather icon changes according to weather condition
- ✅ Responsive and works on **mobile, web, and desktop**

---

## API

- This app uses **OpenWeatherMap Current Weather API**:  
  [https://openweathermap.org/current](https://openweathermap.org/current)  
- You need to create your own **API Key** and replace it in `main.dart`:

```dart
final String apiKey = "YOUR_API_KEY";
```

🔧 Installation
Clone this repository:

Sao chép mã
```dart
git clone https://github.com/hanth0509/weather_app.git
```

Enter project folder:

```dart
cd weather_app
```
---
**Install dependencies:**
```dart
flutter pub get
```
Run the app:
```dart
flutter run
```
**Screenshots**

/assets/

**How It Works**

  Requests permission for location.
    
  Fetches current weather from OpenWeatherMap using the device's latitude and longitude.
    
  Parses JSON response to extract:
    
  City name
    
  Temperature
    
  Weather description
    
  Humidity, wind, pressure
    
  Displays data in a beautiful card with gradient background and dynamic weather icon.

🌟 Notes
    
  Free OpenWeatherMap API keys may have rate limits, avoid excessive requests.
    
  The app currently displays only 1-day weather, perfect for a minimal and clean design.
