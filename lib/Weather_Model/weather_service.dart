import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final String apiKey;
  late WeatherFactory _weatherFactory;

  WeatherService(this.apiKey) {
    _weatherFactory = WeatherFactory(apiKey);
  }

  Future<Weather> getWeather(String cityName) async {
    try {
      Weather weather =
          await _weatherFactory.currentWeatherByCityName(cityName);
      return weather;
    } catch (e) {
      throw Exception('Failed to get weather data: $e');
    }
  }

  Future<String> getcurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

//Fetch Location...........
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemark[0].locality;
    return city ?? "";
  }
}
