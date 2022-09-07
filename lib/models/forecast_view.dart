import 'forecast_domain.dart';

class ForecastView{
  CurrentWeather currentWeather;
  List<Day> days;

  ForecastView({this.days, this.currentWeather});
}

class Day{
  List<DayPart> dayParts;
  DateTime date;
  List<double> weatherCodes;

  Day({this.date, this.dayParts, this.weatherCodes});
}

class DayPart {
  int id;
  double minT;
  double maxT;
  double minSpeed;
  double maxSpeed;
  DateTime date;

  DayPart({this.id, this.maxSpeed, this.maxT, this.minSpeed, this.minT, this.date});
}

class Filters{
  Location location;
  DateTime start;
  DateTime end;

  Filters({this.start, this.end, this.location});
}

class Location{
  String name;
  double latitude;
  double longitude;

  Location({this.longitude, this.latitude, this.name});
}
