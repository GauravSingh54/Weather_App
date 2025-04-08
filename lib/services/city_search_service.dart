import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CitySearchService {
  final String apiKey;
  final String baseUrl = 'http://api.weatherapi.com/v1';

  CitySearchService({required this.apiKey});

  Future<List<String>> searchCities(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.json?key=$apiKey&q=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((city) => city['name'] as String).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error searching cities: $e');
      return [];
    }
  }
}
