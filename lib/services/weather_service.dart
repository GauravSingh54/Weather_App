import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart' as weather_model;

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.weatherapi.com/v1';

  WeatherService({required this.apiKey});

  Future<weather_model.WeatherModel> getCurrentWeather(String cityName) async {
    try {
      final encodedCityName = Uri.encodeComponent(cityName);
      final response = await http.get(
        Uri.parse('$baseUrl/current.json?key=$apiKey&q=$encodedCityName'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['location'];
        final current = data['current'];
        current['location_name'] =
            '${location['name']}, ${location['country']}';
        return weather_model.WeatherModel.fromJson(current);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Failed to load weather data: ${errorData['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from the API');
      }
      rethrow;
    }
  }

  Future<List<weather_model.WeatherForecastModel>> getWeatherForecast(
      String cityName) async {
    try {
      final encodedCityName = Uri.encodeComponent(cityName);
      final response = await http.get(
        Uri.parse(
            '$baseUrl/forecast.json?key=$apiKey&q=$encodedCityName&days=5'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastDays = data['forecast']['forecastday'];
        return forecastDays
            .map((day) => weather_model.WeatherForecastModel.fromJson(day))
            .toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Failed to load forecast data: ${errorData['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from the API');
      }
      rethrow;
    }
  }
}
