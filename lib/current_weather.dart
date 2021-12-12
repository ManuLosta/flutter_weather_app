import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_weather_app/weather_api.dart';

class CurrentWeather extends StatefulWidget {
  const CurrentWeather(this.currentTemp, this.statusBarHeight, {Key? key})
      : super(key: key);

  final Weather? currentTemp;
  final double statusBarHeight;

  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 69 - widget.statusBarHeight),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height - 270,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff00b4d8),
                Color(0xff0077b6),
              ]),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              margin: const EdgeInsets.only(
                bottom: 15.0,
              ),
              child: Text(
                widget.currentTemp!.day.toString(),
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              )),
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(widget.currentTemp!.image.toString()),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.currentTemp!.current.toString(),
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 75.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 14.0),
                child: Text(
                  '°C',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
            ],
          ),
          Text(
            widget.currentTemp!.name.toString(),
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 30.0,
              bottom: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.air,
                        color: Color(0xff030317),
                      ),
                      Text(
                        widget.currentTemp!.wind.toString() + 'km/h',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Wind',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff030317),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.water,
                        color: Color(0xff030317),
                      ),
                      Text(
                        widget.currentTemp!.humidity.toString() + '%',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Humidity',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff030317),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Color(0xff030317),
                      ),
                      Text(
                        widget.currentTemp!.pressure.toString() + ' mBar',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Pressure',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff030317),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
