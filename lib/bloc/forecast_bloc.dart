import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:weather_forecast/api/forecast_client.dart';
import 'package:weather_forecast/helpers/geo_data.dart';
import 'package:weather_forecast/helpers/location_helper.dart';
import 'package:weather_forecast/models/forecast_domain.dart';
import 'package:weather_forecast/models/forecast_view.dart';

import 'bloc.dart';

class UiData {
  ForecastView forecastView;
  Filters filters;
  List<Location> locations;

  UiData({this.forecastView, this.filters, this.locations});
}

class ForecastUiState {
  UiState uiState;
  UiData uiData;

  ForecastUiState(this.uiState, {this.uiData});

  factory ForecastUiState.normal(UiData uiData) => ForecastUiState(UiState.normal, uiData: uiData);
  factory ForecastUiState.loading() => ForecastUiState(UiState.loading);
  factory ForecastUiState.error() => ForecastUiState(UiState.error);
}

class ForecastBloc implements Bloc {
  final _controller = StreamController<ForecastUiState>();
  UiData uiData;
  Stream<ForecastUiState> get stream => _controller.stream;

  ForecastClient _client = ForecastClient();

  @override
  void dispose() {}

  void init() async {
    try {
      _controller.sink.add(ForecastUiState.loading());
      Filters filters = await initFilters();
      ForecastView data = await query(filters);
      List<Location> locations = await GeoData.getLocations();

      uiData = UiData(
        filters: filters,
        forecastView: data,
        locations: locations,
      );

      _controller.sink.add(ForecastUiState.normal(uiData));
    } catch (e) {
      _controller.sink.add(ForecastUiState.error());
    }
  }

  Future<Filters> initFilters () async {
    Position position = await LocationHelper.determinePosition();

    return new Filters(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(days: 7)),
      location: Location(
        name: position != null ? GeoData.CITIES[0] : GeoData.CITIES[1],
        latitude: position?.latitude ?? GeoData.LATITUDES[1],
        longitude: position?.longitude ?? GeoData.LONGITUDES[1],
      ),
    );
  }

  updateFilters(Filters filters) async {
    try {
      _controller.sink.add(ForecastUiState.loading());
      uiData.filters = filters;
      ForecastView data = await query(uiData.filters);
      uiData.forecastView = data;
      _controller.sink.add(ForecastUiState.normal(uiData));
    } catch (e) {
      _controller.sink.add(ForecastUiState.error());
    }
  }

  Future<ForecastView> query(Filters filters) async {
    ForecastDomain forecastDomain = await _client.fetchForecast(filters);
    return this.fromDomainToView(forecastDomain);
  }

  ForecastView fromDomainToView(ForecastDomain model){
    List<double> tempTemperatures = [];
    List<double> tempSpeeds = [];
    List<DayPart> dayParts = [];
    List<Day> days = [];
    List<double> values = [];
    List<int> quantities = [];

    void createDayPart(int i){
      dayParts.add(
        new DayPart(
          id : ((i + 2) ~/ 6 ) % 4,
          maxSpeed: tempSpeeds.reduce(max),
          minSpeed: tempSpeeds.reduce(min),
          maxT: tempTemperatures.reduce(max),
          minT: tempTemperatures.reduce(min),
          date: DateTime.parse(model.time[i]),
        ),
      );
      tempSpeeds = [];
      tempTemperatures = [];
    }

    void createDay(int i, List<double> codes){
      days.add(
        new Day(
            dayParts: dayParts,
            date: dayParts[0].date,
            weatherCodes: codes
        ),
      );
      dayParts = [];
      values = [];
      quantities = [];
    }

    void fill(int i){
      double code = model.weatherCodeHourly[i];
      if (values.contains(code))
        quantities[values.indexOf(code)]++;
      else {
        values.add(code);
        quantities.add(1);
      }
      tempSpeeds.add(model.windSpeedHourly[i]);
      tempTemperatures.add(model.temperatureHourly[i]);
    }

    List<double> getPopularCodes(){
      List<double> codes = [];
      for (int j = 0; j <= 1; j++){
        if (quantities.isNotEmpty){
          int maxIndex = quantities.indexOf(quantities.reduce(max));
          codes.add(values[maxIndex]);
          values.removeAt(maxIndex);
          quantities.removeAt(maxIndex);
        }
      }
      return codes;
    }

    for (int i = 0; i < model.temperatureHourly.length; i++){
      fill(i);
      if ((i + 2) % 6 == 0 || i == model.temperatureHourly.length - 1)
        createDayPart(i);

      if (dayParts.length == 4) {
        List<double> weatherCodes = getPopularCodes();
        createDay(i, weatherCodes);
      }
    }

    return new ForecastView(
      currentWeather: model.currentWeather,
      days: days
    );
  }
}
