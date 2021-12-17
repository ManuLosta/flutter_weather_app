import 'package:flutter/material.dart';
import 'package:flutter_weather_app/current_weather.dart';
import 'package:flutter_weather_app/today_weather.dart';
import 'package:flutter_weather_app/weather_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    String? city;
    if (placemarks[0].subLocality != '') {
      city = placemarks[0].subLocality;
    } else if (placemarks[0].locality != '') {
      city = placemarks[0].locality;
    } else {
      city = placemarks[0].administrativeArea;
    }

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
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: const Color(0xff030317),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  RefreshIndicator(
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: currentTemp!.colors),
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
