import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationHelper{
  static Future<Position> determinePosition() async {
    bool check = await checkPermissions();
    if (check)
      return await Geolocator.getCurrentPosition();
    return null;
  }

  static Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission != LocationPermission.denied && permission != LocationPermission.deniedForever;
  }

  static Future<bool> requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever)
      return false;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return await checkPermissions();
    }
    return true;
  }
}
