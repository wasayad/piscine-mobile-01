import 'package:flutter/material.dart';
import '../weather/WeatherCode.dart';
import '../weather/currentWeather.dart';

class Currently extends StatefulWidget {
  final Weather weather;

  const Currently({
    super.key,
    required this.weather,
  });

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  WeatherCode weatherCode = WeatherCode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: (() {
        List<Widget> ret = [];
        if (widget.weather.curWeather.location.contains("Error")) {
          ret.add(Text(
              style: const TextStyle(color: Colors.red),
              widget.weather.curWeather.location));
          return ret;
        }

        ret.add(Text(widget.weather.curWeather.location));
        ret.add(Text(widget.weather.curWeather.temperature));
        ret.add(Text(weatherCode.weatherCode[widget.weather.curWeather.weather]
            ['text']));
        ret.add(Text(widget.weather.curWeather.windSpeed));
        return ret;
      }()),
    );
  }
}
