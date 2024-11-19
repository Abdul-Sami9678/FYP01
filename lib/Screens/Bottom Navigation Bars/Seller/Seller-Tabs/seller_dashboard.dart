import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Import for reverse geocoding
import 'package:geolocator/geolocator.dart'; // Import for geolocation
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller_Widget_Functions/WaterDetails.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller_Widget_Functions/seedDetails.dart';
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

  // Function to show bottom sheet with more weather details
  void _showWeatherDetails() {
    showModalBottomSheet(
      backgroundColor: const Color(0XFFFFFFFF),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(33.0),
        ),
      ), // Rounded corners for the bottom sheet
      isScrollControlled:
          true, // Makes the bottom sheet scrollable if content overflows
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.34, // Adjust the height of the bottom sheet
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather details organized in a grid-like structure (2 items per row)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10, // Horizontal space between items
                  runSpacing: 10, // Vertical space between rows
                  children: [
                    // Each item will take half of the available width
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) -
                          30, // Two items per row
                      child: _buildDetailCard(
                        icon: Icons.thermostat_rounded,
                        iconColor: Colors.red,
                        label: "Max",
                        value:
                            "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 30,
                      child: _buildDetailCard(
                        icon: Icons.thermostat_auto,
                        iconColor: Colors.blue,
                        label: "Min",
                        value:
                            "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 30,
                      child: _buildDetailCard(
                        icon: Icons.wind_power,
                        iconColor: Colors.green,
                        label: "Wind Speed",
                        value: "${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 30,
                      child: _buildDetailCard(
                        icon: Icons.water_drop,
                        iconColor: Colors.blueAccent,
                        label: "Humidity",
                        value: "${_weather?.humidity?.toStringAsFixed(0)}%",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// This widget will create a weather detail card with an icon and corresponding value
  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.yellow[0], // Adjust the background color as needed
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
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
              GestureDetector(
                onTap: _showWeatherDetails, // Trigger bottom sheet on tap
                child: _buildWeatherCard(),
              ),
              const SizedBox(height: 40),
              // Add additional items below here in the future
              const Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text(
                  "Water Schedule",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sans',
                      letterSpacing: -0.5),
                ),
              ),
              const SizedBox(height: 7),
              const WaterCards(),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text(
                  "Seedling Navigaton",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sans',
                      letterSpacing: -0.5),
                ),
              ),
              const SizedBox(height: 7),
              const SeedCards(),
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
        // Set the asset image inside the card
        // Set the NetworkImage inside the card
        image: const DecorationImage(
          image: NetworkImage(
              'https://plus.unsplash.com/premium_photo-1669809948017-518b5d800d73?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), // Use NetworkImage
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
