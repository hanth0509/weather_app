import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeatherOneDay',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool loading = true;

  final String apiKey = "7bf390fc4a24fd86bf79c2041e54a033"; 

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      await Geolocator.requestPermission();
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&units=metric&appid=$apiKey");

      final res = await http.get(url);

      if (res.statusCode == 200) {
        setState(() {
          weatherData = json.decode(res.body);
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
      print("Error: $e");
    }
  }

  LinearGradient _backgroundGradient(String weather) {
    weather = weather.toLowerCase();
    if (weather.contains("clear")) {
      return const LinearGradient(
          colors: [Color(0xFFfceabb), Color(0xFFf8b500)]);
    } else if (weather.contains("cloud")) {
      return const LinearGradient(
          colors: [Color(0xFFd7d2cc), Color(0xFF304352)]);
    } else if (weather.contains("rain")) {
      return const LinearGradient(
          colors: [Color(0xFF4ca1af), Color(0xFFc4e0e5)]);
    } else {
      return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : weatherData == null
              ? const Center(
                  child: Text(
                    "Không lấy được dữ liệu",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      gradient: _backgroundGradient(
                          weatherData!['weather'][0]['main'])),
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Card chính
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1),
                            ),
                            child: Column(
                              children: [
                                // Icon
                                Icon(
                                  _getWeatherIcon(
                                      weatherData!['weather'][0]['main']),
                                  size: 80,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 15),
                                // Nhiệt độ
                                Text(
                                  "${weatherData!['main']['temp'].round()}°C",
                                  style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                // Tên thành phố
                                Text(
                                  "${weatherData!['name']}, ${weatherData!['sys']['country']}",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                // Mô tả thời tiết
                                Text(
                                  weatherData!['weather'][0]['description']
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(height: 15),
                                // Thông số khác
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _infoTile(
                                        "💧",
                                        "${weatherData!['main']['humidity']}%"),
                                    const SizedBox(width: 20),
                                    _infoTile(
                                        "🌬️",
                                        "${weatherData!['wind']['speed']} m/s"),
                                    const SizedBox(width: 20),
                                    _infoTile(
                                        "🌡️",
                                        "${weatherData!['main']['pressure']} hPa"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  IconData _getWeatherIcon(String main) {
    main = main.toLowerCase();
    if (main.contains("cloud")) return Icons.wb_cloudy;
    if (main.contains("rain")) return Icons.grain;
    if (main.contains("snow")) return Icons.ac_unit;
    if (main.contains("clear")) return Icons.wb_sunny;
    return Icons.wb_sunny;
  }

  Widget _infoTile(String emoji, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
