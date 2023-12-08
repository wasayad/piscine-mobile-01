import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/component/weather/currentWeather.dart';
import 'geolocation/geolocation.dart';

Future<Weather> getWeather(bool shouldRefreshPos) async {
  List<dynamic> ret = [];
  List<Placemark>? locations;
  http.Response res;
  Position coordinate = await determinePosition();
  locations =
      await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
  res = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${coordinate.latitude}&longitude=${coordinate.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max'));
  dynamic body = jsonDecode(res.body);
  ret.add(locations);
  ret.add(body);
  Weather weather = Weather.fromJson(ret);
  return weather;
}
