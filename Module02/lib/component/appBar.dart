import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import '../component/geolocation/geolocation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import './geolocation/position.dart';
import 'package:geocoding/geocoding.dart';
import './weather/currentWeather.dart';

class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  const AppBarComponent(
      {required this.onWeatherChange, required this.onChanged, super.key});

  final ValueChanged<String> onChanged;
  final ValueChanged<Weather> onWeatherChange;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

Future<http.Response> getCity(String country) {
  return http.get(Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$country&count=15'));
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 200,
      width: 200,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 4,
              child: TypeAheadField<Pos>(

                builder: (context, controller, focusNode) {
                  return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: false,
                      onSubmitted: (e) async {
                        Response res = await getCity(e);
                        List<Pos> locations = [];
                        Pos location;
                        dynamic body = json.decode(res.body);
                        if (body.containsKey("results")) {
                          for (var city in body["results"]) {
                            location = Pos.fromJson(city);
                            locations.add(location);
                          }
                        }
                        List<dynamic> ret = [];
                        List<Pos> city = [];
                        city.add(locations[0]);
                        List<Placemark>? loc;
                        Weather weather = Weather();
                        try {
                          res = await http.get(Uri.parse(
                              'https://api.open-meteo.com/v1/forecast?latitude=${locations[0].latitude}&longitude=${locations[0].longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max'));
                          dynamic body = jsonDecode(res.body);
                          ret.add(city);
                          ret.add(body);
                          weather = Weather.fromJson(ret);
                        } on Exception catch (_) {
                          weather.curWeather.location =
                          "Error The connection service is lost, please check your internet connection or try again later";
                          weather.dayWeather.location =
                          "Error The connection service is lost, please check your internet connection or try again later";
                          weather.weekWeather.location =
                          "Error The connection service is lost, please check your internet connection or try again later";
                        }
                        widget.onWeatherChange(weather);
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'City'));
                },
                itemBuilder: (BuildContext context, Pos value) {
                  return ListTile(
                    title: Text(value.name),
                    subtitle: Text('${value.country}, ${value.locality}'),
                  );
                },
                onSelected: (Pos value) async {
                  List<dynamic> ret = [];
                  List<Pos> city = [];
                  city.add(value);
                  List<Placemark>? locations;
                  http.Response res;
                  Weather weather = Weather();
                  try {
                    res = await http.get(Uri.parse(
                        'https://api.open-meteo.com/v1/forecast?latitude=${value.latitude}&longitude=${value.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max'));
                    dynamic body = jsonDecode(res.body);
                    ret.add(city);
                    ret.add(body);
                    weather = Weather.fromJson(ret);
                  } on Exception catch (_) {
                    weather.curWeather.location =
                        "Error The connection service is lost, please check your internet connection or try again later";
                    weather.dayWeather.location =
                        "Error The connection service is lost, please check your internet connection or try again later";
                    weather.weekWeather.location =
                        "Error The connection service is lost, please check your internet connection or try again later";
                  }
                  widget.onWeatherChange(weather);
                },
                suggestionsCallback: (String search) async {
                  Response res = await getCity(search);
                  List<Pos> locations = [];
                  Pos location;
                  dynamic body = json.decode(res.body);
                  if (body.containsKey("results")) {
                    for (var city in body["results"]) {
                      location = Pos.fromJson(city);
                      locations.add(location);
                    }
                  }
                  return locations;
                },
                errorBuilder: (context, error) =>
                   const ListTile(
                      title: Text(style: TextStyle(color: Colors.red), "The connection service is lost, please check your internet connection or try again later"),
                    ),
              )),
          Expanded(
              child: IconButton(
            icon: const Icon(Icons.map),
            onPressed: () async {
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
                widget.onWeatherChange(weather);
              }
              if (!serviceEnabled) {
                print("error");
                weather = Weather();
                weather.curWeather.location = "Error gps not working or may be disabled";
                weather.dayWeather.location = "Error gps not working or may be disabled";
                weather.weekWeather.location ="Error gps not working or may be disabled";
                widget.onWeatherChange(weather);
              }
              if (permission == LocationPermission.denied) {
                print("error");
                if (permission == LocationPermission.denied) {
                  print("error");
                  weather = Weather();
                  weather.curWeather.location = "Error gps not working or may be disabled";
                  weather.dayWeather.location = "Error gps not working or may be disabled";
                  weather.weekWeather.location ="Error gps not working or may be disabled";
                  widget.onWeatherChange(weather);
                }
              }
              Position coordinate = await determinePosition();
              try {
                locations = await placemarkFromCoordinates(
                    coordinate.latitude, coordinate.longitude);
                res = await http.get(Uri.parse(
                    'https://api.open-meteo.com/v1/forecast?latitude=${coordinate.latitude}&longitude=${coordinate.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max'));
                dynamic body = jsonDecode(res.body);
                ret.add(locations);
                ret.add(body);
                weather = Weather.fromJson(ret);
              } on Exception catch (_) {
                weather = Weather();
                weather.curWeather.location =
                    "Error The connection service is lost, please check your internet connection or try again later";
                weather.dayWeather.location =
                    "Error The connection service is lost, please check your internet connection or try again later";
                weather.weekWeather.location =
                    "Error The connection service is lost, please check your internet connection or try again later";
              }
              widget.onWeatherChange(weather);
            },
            iconSize: 50,
          )),
        ],
      ),
    );
  }
}
