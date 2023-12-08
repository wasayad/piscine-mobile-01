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
                      autofocus: true,
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
                  res = await http.get(Uri.parse(
                      'https://api.open-meteo.com/v1/forecast?latitude=${value.latitude}&longitude=${value.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max'));
                  dynamic body = jsonDecode(res.body);
                  ret.add(city);
                  ret.add(body);
                  Weather weather = Weather.fromJson(ret);
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
              )),
          Expanded(
              child: IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => {
              determinePosition().then((result) {
                setState(() async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      result.latitude, result.longitude);
                  String? city = placemarks[0].locality;
                  widget.onChanged("$city");
                });
              }).catchError((error) {
                setState(() {
                  debugPrint(error.toString());
                  widget.onChanged(error.toString());
                });
              }),
            },
            iconSize: 50,
          )),
        ],
      ),
    );
  }
}
