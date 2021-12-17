import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

String appId = '5bce6a8a900bb25076c09d5dc66d0fc3';

class Weather {
  final int? current;
  final String? name;
  final String? day;
  final int? wind;
  final int? humidity;
  final int? pressure;
  final int? uvIndex;
  final String? image;
  final int? pop;
  final String? time;
  final List<Color> colors;

  Weather({
    this.name,
    this.day,
    this.wind,
    this.humidity,
    this.pressure,
    this.uvIndex,
    this.image,
    this.current,
    this.pop,
    this.time,
    required this.colors,
  });
}

Future<List> fetchData(String lat, String lon) async {
  final res = await get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId'));

  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var current = data["current"];

    DateTime date = DateTime.fromMillisecondsSinceEpoch(
            (current['dt'] + data['timezone_offset']) * 1000)
        .toUtc();

    int sunrise = DateTime.fromMillisecondsSinceEpoch(
            (current['sunrise'] + data['timezone_offset']) * 1000)
        .toUtc()
        .hour;
    int sunset = DateTime.fromMillisecondsSinceEpoch(
            (current['sunset'] + data['timezone_offset']) * 1000)
        .toUtc()
        .hour;

    Weather currentTemp = Weather(
        current: current["temp"].round(),
        name: current["weather"][0]["main"].toString(),
        day: DateFormat("EEEE MMMM dd, HH:mm").format(date),
        wind: (current["wind_speed"] * 3.6).round(),
        humidity: current["humidity"].round(),
        pressure: current['pressure'].round(),
        uvIndex: current["uvi"].round(),
        image: findIcon(
            current["weather"][0]["main"].toString(), date, sunrise, sunset),
        colors: findColors(date, sunrise, sunset));

    List<Weather> todayWeather = [];
    for (var i = 0; i < 31 - date.hour; i++) {
      var temp = data['hourly'];
      var hourly = Weather(
          current: temp[i]["temp"].round(),
          image: findIcon(
              temp[i]["weather"][0]["main"].toString(), date, sunrise, sunset),
          pop: (temp[i]['pop'] * 100).round(),
          colors: [],
          time: DateFormat('HH').format(DateTime.fromMillisecondsSinceEpoch(
                  (temp[i]['dt'] + data['timezone_offset']) * 1000)
              .toUtc()));
      todayWeather.add(hourly);
    }

    return [currentTemp, todayWeather];
  }
  throw Exception;
}

String findIcon(String name, DateTime date, int sunrise, int sunset) {
  if (sunrise < date.hour && date.hour < sunset) {
    switch (name) {
      case 'Clear':
        return 'assets/img/sunny.png';
      case 'Clouds':
        return 'assets/img/clouds.png';
      case 'Rain':
        return 'assets/img/rain.png';
      default:
        return 'assets/img/sunny.png';
    }
  } else {
    switch (name) {
      case 'Clear':
        return 'assets/img/night_clear.png';
      case 'Clouds':
        return 'assets/img/night_clouds.png';
      case 'Rain':
        return 'assets/img/night_rain.png';
      default:
        return 'assets/img/night_clear.png';
    }
  }
}

List<Color> findColors(DateTime date, int sunrise, int sunset) {
  if (sunrise < date.hour && date.hour < sunset) {
    return [const Color(0xff00b4d8), const Color(0xff0077b6)];
  } else {
    return [const Color(0xffa356eb), const Color(0xff9136e7)];
  }
}
