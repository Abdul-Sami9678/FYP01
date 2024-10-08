import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Import for reverse geocoding
import 'package:geolocator/geolocator.dart'; // Import for geolocation
import 'package:weather/weather.dart';

class SellerDashboardHome extends StatefulWidget {
  const SellerDashboardHome({super.key});

  @override
  State<SellerDashboardHome> createState() => _SellerDashboardHomeState();
}

class _SellerDashboardHomeState extends State<SellerDashboardHome> {
  final WeatherFactory _wf = WeatherFactory('5910f89a02fcf503fe6435de4e154da8');
  Weather? _weather;
  String cityName = 'Loading City...';
  String countryName = '';
  String? weatherIconUrl;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      _getCityNameFromCoordinates(position.latitude, position.longitude)
          .then((fetchedCityName) {
        setState(() {
          cityName = fetchedCityName[0]; // City name
          countryName = fetchedCityName[1]; // Country name
        });
        _wf.currentWeatherByCityName(fetchedCityName[0]).then((w) {
          setState(() {
            _weather = w;
            weatherIconUrl =
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png";
          });
        });
      });
    });
  }

  // Get current position (latitude, longitude)
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  // Reverse geocode to get the city and country name from latitude and longitude
  Future<List<String>> _getCityNameFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0]; // We take the first placemark result
    return [
      place.locality ?? "Unknown City",
      place.country ?? "Unknown Country"
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 50),
          child: Center(
            child: _buildWeatherCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // Changed the card color to a unique one
        color: Colors.deepPurpleAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _weather == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temperature and Wind Speed Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Temperature
                        Text(
                          "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
                          style: const TextStyle(
                            fontSize:
                                40, // Reduced font size to fit more content
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Wind speed with icon
                        Row(
                          children: [
                            const Icon(
                              Icons.wind_power, // Wind icon
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Weather Icon
                    if (weatherIconUrl != null)
                      Image.network(
                        weatherIconUrl!,
                        height: 60,
                        width: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // City and Country name
                Text(
                  '$cityName, $countryName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
    );
  }
}
