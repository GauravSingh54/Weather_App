import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/city_search_service.dart';

class CitySearchProvider with ChangeNotifier {
  final CitySearchService _citySearchService;
  List<String> _suggestions = [];
  Timer? _debounceTimer;
  bool _isLoading = false;

  CitySearchProvider(this._citySearchService);

  List<String> get suggestions => _suggestions;
  bool get isLoading => _isLoading;

  void searchCities(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        _suggestions = [];
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      try {
        _suggestions = await _citySearchService.searchCities(query);
      } catch (e) {
        debugPrint('Error searching cities: $e');
        _suggestions = [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearSuggestions() {
    _suggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
