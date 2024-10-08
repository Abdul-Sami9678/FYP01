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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather Card positioned at the top
              _buildWeatherCard(),
              const SizedBox(height: 20),
              // Add additional items below here in the future
              Text(
                "Additional items can be placed here...",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ],
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
        // Set the background image inside the card
        image: const DecorationImage(
          image: NetworkImage(
              'https://plus.unsplash.com/premium_photo-1669809948017-518b5d800d73?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 136, 128, 128).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _weather == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temperature, Wind Speed, and Weather Icon Row
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
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // White text to contrast with the background
                          ),
                        ),
                        const SizedBox(width: 12),
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
                                color: Colors
                                    .white, // White text to contrast with the background
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
                const SizedBox(height: 2),
                // City and Country name
                Text(
                  '$cityName, $countryName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors
                        .white, // White text to contrast with the background
                  ),
                ),
              ],
            ),
    );
  }
}
