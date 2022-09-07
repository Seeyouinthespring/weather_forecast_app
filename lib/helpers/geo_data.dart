import 'package:geolocator/geolocator.dart';
import 'package:weather_forecast/models/forecast_view.dart';

import 'location_helper.dart';

class GeoData {
  GeoData._();

  static const List<String> CITIES = ['Текущая', 'Москва', 'Лондон', 'Нью-Йорк', 'Афины', 'Осло', 'Джакарта'];
  static const List<double> LATITUDES = [0, 55.7558, 51.5002, 40.71, 37.9792, 59.9138, -6.1862];
  static const List<double> LONGITUDES = [0, 37.6176, -0.1262, 74.01, 23.7166, 10.7387, 106.8063];

  static Future<List<Location>> getLocations() async {
    bool check = await LocationHelper.checkPermissions();
    Position position;
    if (check)
      position = await LocationHelper.determinePosition();
    List<Location> locations = [];
    for (int i = check ? 0 : 1; i < CITIES.length; i ++)
      locations.add(
        Location(
          name: CITIES[i],
          latitude: i==0 ? position?.latitude ?? 0 : LATITUDES[i],
          longitude: i==0 ? position?.longitude ?? 0 : LONGITUDES[i],
        ),
      );
    return locations;
  }
}
