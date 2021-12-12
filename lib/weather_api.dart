import 'dart:convert';
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
  });
}

Future<List> fetchData(String lat, String lon) async {
  final res = await get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId'));

  DateTime date = DateTime.now();

  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var current = data["current"];
    Weather currentTemp = Weather(
        current: current["temp"]?.round() ?? 0,
        name: current["weather"][0]["main"].toString(),
        day: DateFormat("EEEE MMMM dd, HH:mm").format(date),
        wind: (current["wind_speed"] * 3.6)?.round() ?? 0,
        humidity: current["humidity"]?.round() ?? 0,
        pressure: current['pressure']?.round() ?? 0,
        uvIndex: current["uvi"]?.round() ?? 0,
        image: findIcon(current["weather"][0]["main"].toString()));

    List<Weather> todayWeather = [];
    for (var i = 0; i < 10; i++) {
      var temp = data['hourly'];
      var hourly = Weather(
          current: temp[i]["temp"]?.round() ?? 0,
          image: findIcon(temp[i]["weather"][0]["main"].toString()),
          pop: (temp[i]['pop'] * 100).round(),
          time: DateFormat('HH').format(
              DateTime.fromMillisecondsSinceEpoch(temp[i]['dt'] * 1000)));
      todayWeather.add(hourly);
    }

    return [currentTemp, todayWeather];
  }
  throw Exception;
}

String findIcon(String name) {
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
}
