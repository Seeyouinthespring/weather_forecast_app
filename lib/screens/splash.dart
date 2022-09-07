import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_forecast/helpers/location_helper.dart';

import '../routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () async {
      await LocationHelper.requestPermissions();
      await Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.sun_haze_fill, color: Colors.black),
              Text('Weather Forecast', style: TextStyle(color: Colors.black, fontSize: 28),)
            ],
          )
      ),
    );
  }
}
