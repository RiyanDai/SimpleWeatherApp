class WeatherModel {
  final String city;
  final String country;
  final double temperature;
  final String mainCondition;


  WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.mainCondition,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'],
      mainCondition: json['weather'][0]['main'],
    );
  }
}