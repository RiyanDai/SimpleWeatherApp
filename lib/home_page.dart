import 'package:flutter/material.dart';
import 'package:flutter_weatherapp/models/weather_models.dart';
import 'package:flutter_weatherapp/services/weather_services.dart';
import 'package:lottie/lottie.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const apikey = "4eef79fe0049e35d221c4e52de59eafd";

  //api key
  final _weatherService = WeatherService(apikey);
  WeatherModel? _weather;

  //fetch weather
  _fetchWether() async {
    try {
      String city = await _weatherService.getCity();
      print("Retrieved city: $city");

      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error in _fetchWeather: $e");
      // Tampilkan error ke user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  //weather animations

  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    _fetchWether();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:
            [ Color.fromARGB(255, 78, 13, 151),
              Color.fromARGB(255, 107, 159, 138),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //city name
             Text(
                _weather?.city ?? "Loading city..",
                style: const TextStyle(fontSize: 44, color: Colors.white),
              ),
              const SizedBox(height: 20),
               //animation
              Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
               //temperature
              Text(
                _weather?.temperature != null 
                  ? "${_weather!.temperature.round()}°C"
                  : "Loading temperature..",
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              const SizedBox(height: 20,),
              Text(
                _weather?.temperature != null
                    ? _weather!.mainCondition
                    : "Loading...",
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
