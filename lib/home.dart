import 'package:flutter/material.dart';
import 'package:flutter_weather_app/cities_api.dart';
import 'package:flutter_weather_app/current_weather.dart';
import 'package:flutter_weather_app/today_weather.dart';
import 'package:flutter_weather_app/weather_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  bool _updating = false;
  Weather? currentTemp;
  List? todayWeather;
  String? _city;
  String? _lat;
  String? _lon;

  getData() async {
    Position pos = await _determinePosition();
    List data =
        await fetchData(pos.latitude.toString(), pos.longitude.toString());
    String city =
        await fetchCity(pos.latitude.toString(), pos.longitude.toString());
    setState(() {
      currentTemp = data[0];
      todayWeather = data[1];
      _loading = false;
      _city = city;
      _lat = pos.latitude.toString();
      _lon = pos.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> refresh() async {
    setState(() {
      _updating = true;
    });

    List data = await fetchData(_lat.toString(), _lon.toString());

    setState(() {
      currentTemp = data[0];
      todayWeather = data[1];
      _updating = false;
    });
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: const Color(0xff030317),
        body: Stack(
          children: [
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    edgeOffset: -1000,
                    child: ListView(
                      children: [
                        CurrentWeather(currentTemp, statusBarHeight),
                        TodayWeather(todayWeather),
                      ],
                    ),
                    onRefresh: refresh),
            Container(
              height: 70.0,
              padding: EdgeInsets.only(top: statusBarHeight),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff00b4d8),
                      Color(0xff0077b6),
                    ]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _updating
                        ? 'Updating...'
                        : _city == null
                            ? 'Current location'
                            : _city.toString(),
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
