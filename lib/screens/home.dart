import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/bloc/bloc.dart';
import 'package:weather_forecast/bloc/forecast_bloc.dart';
import 'package:weather_forecast/components/date_picker_widget.dart';
import 'package:weather_forecast/components/part_of_day_item.dart';
import 'package:weather_forecast/components/search_location_dialog.dart';
import 'package:weather_forecast/helpers/weather_description.dart';
import 'package:weather_forecast/models/forecast_domain.dart';
import 'package:weather_forecast/models/forecast_view.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  ForecastBloc _bloc;
  bool isFiltersOn = false;

  @override
  void initState() {
    _bloc = ForecastBloc();
    _bloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ForecastUiState>(
        stream: _bloc.stream,
        initialData: ForecastUiState.loading(),
        builder: (BuildContext context, AsyncSnapshot<ForecastUiState> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Container(
                alignment: Alignment.center,
                child: Text('Прогноз'),
              ),
            ),
            body: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus.unfocus();
                                  final location = await showDialog(
                                    context: context,
                                    builder: (builderContext) => SearchLocationDialog(items: snapshot.data.uiData.locations),
                                  );
                                  if (location != null){
                                    Filters newFilters = snapshot.data.uiData.filters;
                                    newFilters.location = location;
                                    await _bloc.updateFilters(newFilters);
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(snapshot.data.uiData?.filters?.location?.name ?? '',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Icon(Icons.search,
                                        size: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Row(
                            children:[
                              Expanded(
                                flex:1,
                                child: CustomDatePicker(
                                  maxTime: snapshot.data.uiData?.filters?.end ?? DateTime.now().add(Duration(days: 7)),
                                  value: snapshot.data.uiData?.filters?.start ?? DateTime.now(),
                                  onChange: (value) async {
                                    Filters newFilters = snapshot.data.uiData.filters;
                                    newFilters.start = value;
                                    await _bloc.updateFilters(newFilters);
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex:1,
                                child: CustomDatePicker(
                                  minTime: snapshot.data.uiData?.filters?.start ?? DateTime.now(),
                                  maxTime: DateTime.now().add(Duration(days: 7)),
                                  value: snapshot.data.uiData?.filters?.end ?? DateTime.now().add(Duration(days: 7)),
                                  onChange: (value) async {
                                    Filters newFilters = snapshot.data.uiData.filters;
                                    newFilters.end = value;
                                    await _bloc.updateFilters(newFilters);
                                  },
                                ),
                              ),
                            ]
                        ),
                      ),
                      Divider(color: Colors.black, thickness: 2,)
                    ],
                  ),
                ),

                if (snapshot.data.uiState == UiState.loading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),

                if (snapshot.data.uiState == UiState.error)
                  Center(
                    child: Text('Error'),
                  ),

                if (snapshot.data.uiState == UiState.normal)
                  Expanded(
                    child: ForecastList(model: snapshot.data.uiData.forecastView),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}


class ForecastList extends StatelessWidget{
  final ForecastView model;

  ForecastList({this.model});

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: model.days.length + 2,
          itemBuilder: (context, index) {
            if (index == 0)
              return CurrentForecastItem(currentWeather: model.currentWeather);
            if (index >= model.days.length + 1)
              return Container(
                height: 75,
              );
            final item = model.days[index-1];
            return ForecastItem(key: Key(index.toString()), day: item);
          },
        )
    );
  }
}

class CurrentForecastItem extends StatelessWidget{
  final CurrentWeather currentWeather;

  CurrentForecastItem({Key key, this.currentWeather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Актуальное состояние',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            width: MediaQuery.of(context).size.width,
            child: Text('t : ${currentWeather.temperature} °C',
              style: TextStyle(fontSize: 22, color: Colors.white),
            )
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width,
            child: Text('Ветер : ${WeatherDescription.getWindDirection(currentWeather.windDirection.toInt())} ${currentWeather.windSpeed} м/с',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text('Преимущественно ${WeatherDescription.WEATHER_MAP[currentWeather.weatherCode]}',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class ForecastItem extends StatelessWidget{
  final Day day;

  ForecastItem({Key key, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('${(DateFormat('EEEE, d MMMM', 'ru').format(day.date))}',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                PartOfDayItem(part: day.dayParts[0]),
                PartOfDayItem(part: day.dayParts[1]),
              ],
            ),
          ),
          Row(
            children: [
              PartOfDayItem(part: day.dayParts[2]),
              PartOfDayItem(part: day.dayParts[3]),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  child: Text('Преимущественно ${WeatherDescription.WEATHER_MAP[day.weatherCodes[0]]}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                if (day.weatherCodes.length > 1)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text('Возможно ${WeatherDescription.WEATHER_MAP[day.weatherCodes[1]]}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
