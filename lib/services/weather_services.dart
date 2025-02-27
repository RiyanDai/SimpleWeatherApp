import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weatherapp/models/weather_models.dart';

class WeatherService {

  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apikey;

  WeatherService(this.apikey);

  Future<WeatherModel>getWeather(String city) async{
    final response = await http.get(Uri.parse("$BASE_URL?q=$city&appid=$apikey&units=metric"));

    if(response.statusCode == 200){
      return WeatherModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCity() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("Location services enabled: $serviceEnabled");
    
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check for permissions
    LocationPermission permission = await Geolocator.checkPermission();
    print("Current permission status: $permission");
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("Permission after request: $permission");
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    try {
      print("Getting current position...");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      print("Position obtained: ${position.latitude}, ${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      print("Placemarks obtained: ${placemarks.first.toString()}");
      
      // Prioritaskan subAdministrativeArea (nama kota) daripada locality (kecamatan)
      String? city = placemarks.first.subAdministrativeArea?.replaceAll('Kota ', '');
      if (city == null || city.isEmpty) {
        city = placemarks.first.locality;
      }
      if (city == null || city.isEmpty) {
        city = placemarks.first.administrativeArea;
      }
      
      // Hapus kata "Kota" dari nama kota jika ada
      city = city?.replaceAll('Kota ', '');
      
      print("Final city name: $city");
      return city ?? "Unknown City";
    } catch (e) {
      print('Error getting location: $e');
      throw Exception('Failed to get location: $e');
    }
  }


}
