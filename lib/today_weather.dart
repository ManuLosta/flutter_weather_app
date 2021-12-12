import 'package:flutter/material.dart';
import 'package:flutter_weather_app/weather_api.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayWeather extends StatefulWidget {
  const TodayWeather(this.todayWeather, {Key? key}) : super(key: key);

  final List? todayWeather;

  @override
  _TodayWeatherState createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 15.0,
            right: 15.0,
            bottom: 10.0,
          ),
          child: Text(
            '7 day forecast   >',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.todayWeather!.length,
              itemBuilder: (context, index) {
                return WeatherWidget(widget.todayWeather![index]);
              }),
        )
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget(this.weather, {Key? key}) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.0,
      width: 50.0,
      margin: const EdgeInsets.only(
        right: 15.0,
        left: 15.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.time.toString(),
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 14.0,
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(
              weather.pop!.toInt() >= 40 ? weather.pop.toString() + '%' : '',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Container(
            height: 40.0,
            margin: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(weather.image.toString()),
              ),
            ),
          ),
          Text(
            weather.current.toString() + '°C',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
