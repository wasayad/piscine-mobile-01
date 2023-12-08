import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.weather.curWeather.location),
        Text(widget.weather.curWeather.temperature),
        Text(widget.weather.curWeather.weather),
        Text(widget.weather.curWeather.windSpeed),
      ],
    );
  }
}
