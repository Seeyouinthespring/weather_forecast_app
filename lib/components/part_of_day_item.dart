import 'package:flutter/material.dart';
import 'package:weather_forecast/models/forecast_view.dart';

const TITLES = ['Ночь', 'Утро', 'День', 'Вечер'];

class PartOfDayItem extends StatelessWidget{
  final DayPart part;

  PartOfDayItem({this.part});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(TITLES[part.id], style: TextStyle(fontSize: 16),),
            Text('t: ${part.minT} - ${part.maxT} °C', style: TextStyle(fontSize: 22, color: Colors.white),),
            Text('Ветер: ${part.minSpeed.toInt()} - ${part.maxSpeed.ceil()} м/с', style: TextStyle(fontSize: 16, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
