import 'package:intl/intl.dart';
import 'package:weather_forecast/models/forecast_domain.dart';
import 'package:weather_forecast/models/forecast_view.dart';
import 'package:weather_forecast/network/endpoints.dart';
import 'package:weather_forecast/network/rest_client.dart';

const List<String> HOURLY_WEATHER_PARAMS = ['temperature_2m','windspeed_10m','weathercode'];

class ForecastClient {
  RestClient _client;

  ForecastClient() {
    _client = RestClient();
  }

  Future<ForecastDomain> fetchForecast(Filters filters) async {
    String params = '?';
    params+='&latitude=${filters.location.latitude}';
    params+='&longitude=${filters.location.longitude}';
    params+='&current_weather=true';
    params+='&start_date=${DateFormat("yyyy-MM-dd").format(filters.start)}';
    params+='&end_date=${DateFormat("yyyy-MM-dd").format(filters.end)}';
    HOURLY_WEATHER_PARAMS.forEach((element) {
      params+='&hourly=$element';
    });
    

    dynamic json = await _client.get(Endpoints.forecast, paramsString: params);
    return new ForecastDomain.fromJson(json);
  }
}
