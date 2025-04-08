import 'package:flutter/foundation.dart';
import '../models/weather_model.dart' as weather_model;
import '../services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService;
  weather_model.WeatherModel? _currentWeather;
  List<weather_model.WeatherForecastModel> _forecast = [];
  bool _isLoading = false;
  String? _error;
  List<String> _searchHistory = [];
  weather_model.WeatherModel? _weather;
  String? _lastSearchedCity;

  WeatherProvider(this._weatherService) {
    _loadSearchHistory();
  }

  weather_model.WeatherModel? get currentWeather => _currentWeather;
  List<weather_model.WeatherForecastModel> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get searchHistory => _searchHistory;
  weather_model.WeatherModel? get weather => _weather;
  String? get lastSearchedCity => _lastSearchedCity;

  Future<void> fetchWeatherByCity(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeather(cityName);
      _forecast = await _weatherService.getWeatherForecast(cityName);
    } catch (e) {
      _error = 'Failed to fetch weather data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch weather using coordinates
      _currentWeather = await _weatherService.getCurrentWeather(
        '${position.latitude},${position.longitude}',
      );
      _forecast = await _weatherService.getWeatherForecast(
        '${position.latitude},${position.longitude}',
      );
    } catch (e) {
      _error = 'Failed to fetch weather data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading search history: $e');
      _searchHistory = [];
    }
  }

  Future<void> _addToSearchHistory(String cityName) async {
    try {
      if (!_searchHistory.contains(cityName)) {
        _searchHistory.insert(0, cityName);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('searchHistory', _searchHistory);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error saving search history: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void retryLastSearch() {
    if (_searchHistory.isNotEmpty) {
      fetchWeatherByCity(_searchHistory.first);
    }
  }
}
