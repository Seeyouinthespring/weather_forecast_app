import 'package:collection/collection.dart';

class ForecastDomain {
  CurrentWeather currentWeather;
  List<double> windSpeedHourly;
  List<double> temperatureHourly;
  List<double> weatherCodeHourly;
  List<double> windDirection;
  List<String> time;
  
  ForecastDomain.fromJson(Map<String, dynamic> json){
    this.currentWeather = new CurrentWeather.fromJson(json['current_weather']);
    this.temperatureHourly = (List<double>.from(json['hourly']['temperature_2m'])).whereNotNull().toList();
    this.windSpeedHourly = (List<double>.from(json['hourly']['windspeed_10m'])).whereNotNull().toList();
    this.weatherCodeHourly = (List<double>.from(json['hourly']['weathercode'])).whereNotNull().toList();
    this.time = (List<String>.from(json['hourly']['time'])).whereNotNull().toList();
  }
}

class CurrentWeather{
  double temperature;
  double windSpeed;
  double windDirection;
  double weatherCode;
  DateTime time;

  CurrentWeather.fromJson(Map<String, dynamic> json){
    this.temperature = json['temperature'];
    this.windSpeed = json['windspeed'];
    this.windDirection = json['winddirection'];
    this.weatherCode = json['weathercode'];
    this.time = DateTime.parse(json['time']);
  }
}
