import 'package:flutter/material.dart';
import 'package:weatherapp/component/weather/currentWeather.dart';
import 'package:intl/intl.dart';

class Today extends StatefulWidget {
  Weather weather;

  Today({
    required this.weather,
    super.key,
  });

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<Widget> getList(Weather weather) {
    DateTime now;
    var formatter = DateFormat('hh:mm');
    var formatted;
    List<Widget> childs = [];
      if (weather.curWeather.location.contains("Error")) {
        childs.add(Text(style: const TextStyle(color: Colors.red),weather.curWeather.location));
      }
      else {
        childs.add(Text(weather.curWeather.location));
    }
    if (weather.dayWeather.hours.isNotEmpty) {
      for (var i = 0; i < 24; i++) {
        now = DateTime.parse(weather.dayWeather.hours[i]);
        formatted = formatter.format(now);
        childs.add(Text(
            "$formatted ${weather.dayWeather.temperature[i]
                .toString()}°C ${weather.dayWeather.windSpeed[i]}km/h"));
      }
    }
    return childs;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getList(widget.weather),
          ),
        ));
  }
}
