import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/component/weather/currentWeather.dart';
import 'geolocation/geolocation.dart';

Future<Weather> getWeather() async {
  List<dynamic> ret = [];
  List<Placemark>? locations;
  http.Response res;
  bool serviceEnabled;
  LocationPermission permission;
  Weather weather;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    print("error");
    weather = Weather();
    weather.curWeather.location = "Error gps not working or may be disabled";
    weather.dayWeather.location = "Error gps not working or may be disabled";
    weather.weekWeather.location ="Error gps not working or may be disabled";
    return weather;
  }
  if (!serviceEnabled) {
    print("error");
    weather = Weather();
    weather.curWeather.location = "Error gps not working or may be disabled";
    weather.dayWeather.location = "Error gps not working or may be disabled";
    weather.weekWeather.location ="Error gps not working or may be disabled";
    return weather;
  }
  if (permission == LocationPermission.denied) {
    print("error");
    if (permission == LocationPermission.denied) {
      print("error");
      weather = Weather();
      weather.curWeather.location = "Error gps not working or may be disabled";
      weather.dayWeather.location = "Error gps not working or may be disabled";
      weather.weekWeather.location ="Error gps not working or may be disabled";
      return weather;
    }
  }
  Position coordinate = await determinePosition();

  try {
    locations =
    await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
    res = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${coordinate
            .latitude}&longitude=${coordinate
            .longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max'));
    dynamic body = jsonDecode(res.body);
    ret.add(locations);
    ret.add(body);
    weather = Weather.fromJson(ret);
  }
  on Exception catch (_) {
    weather = Weather();
    weather.curWeather.location = "Error The connection service is lost, please check your internet connection or try again later";
    weather.dayWeather.location = "Error The connection service is lost, please check your internet connection or try again later";
    weather.weekWeather.location ="Error The connection service is lost, please check your internet connection or try again later";
  }
  return weather;
}
