import 'package:flutter/material.dart';
import 'package:rice_application/Weather_Model/weather_service.dart';
import 'package:weather/weather.dart';

class WeatherSeller extends StatefulWidget {
  const WeatherSeller({super.key});

  @override
  State<WeatherSeller> createState() => _WeatherSellerState();
}

class _WeatherSellerState extends State<WeatherSeller> {
  // API-KEY...
  final _weatherService = WeatherService('5910f89a02fcf503fe6435de4e154da8');
  Weather? _weather;
  String errorMessage = '';

  // Fetch Weather.......
  Future<void> _fetchWeather() async {
    try {
      // Assuming the method to get the current city exists
      String cityName = await _weatherService.getcurrentCity();

      // Get city weather.........
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching weather: $e';
        print(e); // Debugging: Log error to console
      });
    }
  }

  // initState........
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: _weather == null
            ? errorMessage.isNotEmpty
                ? Text(errorMessage) // Display error if there's an issue
                : const CircularProgressIndicator() // Show loading indicator if no data yet
            : SingleChildScrollView(
                // Ensure content is scrollable if it overflows
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // City Name......
                    Text(
                      _weather?.areaName ??
                          "City name not available", // Use areaName for city
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20), // Spacing

                    // Temperature.....
                    Text(
                      _weather?.temperature?.celsius != null
                          ? '${_weather!.temperature!.celsius!.round()}°C'
                          : "Temperature not available",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
