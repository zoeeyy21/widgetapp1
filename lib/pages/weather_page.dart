import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:widgetapp/models/weather.model.dart';
import 'package:widgetapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('4397b4e0d3195d541130829058e93047');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //any errors
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain slow.json';
      case 'thunderstorm':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 122, 161),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(
              _weather?.cityName ?? "Loading city..",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800),
              // Change text color to white
            ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            // temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800),
            ),
            //weather condition
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
