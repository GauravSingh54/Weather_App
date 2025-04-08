import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'providers/weather_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/city_search_provider.dart';
import 'services/weather_service.dart';
import 'services/city_search_service.dart';
import 'widgets/weather_card.dart';
import 'widgets/forecast_list.dart';
import 'widgets/loading_shimmer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherService(apiKey: '060bb1c03b0e471c95a54001250804'),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CitySearchProvider(
            CitySearchService(apiKey: '060bb1c03b0e471c95a54001250804'),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeProvider.themeMode,
            home: const WeatherHomePage(),
          );
        },
      ),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      if (mounted) {
        context.read<WeatherProvider>().fetchWeatherByLocation();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.indigo,
        elevation: 4,
        title: _isSearching
            ? Consumer<CitySearchProvider>(
                builder: (context, citySearchProvider, child) {
                  return Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search city...',
                          border: InputBorder.none,
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          citySearchProvider.searchCities(value);
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            context
                                .read<WeatherProvider>()
                                .fetchWeatherByCity(value);
                            citySearchProvider.clearSuggestions();
                          }
                          setState(() {
                            _isSearching = false;
                          });
                        },
                      ),
                      if (citySearchProvider.isLoading)
                        const SizedBox(
                          height: 2,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                    ],
                  );
                },
              )
            : const Text(
                'Weather App',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<CitySearchProvider>().clearSuggestions();
                } else {
                  _searchFocusNode.requestFocus();
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/night_sky.jpg'
                      : 'assets/day_sky.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (_isLoadingLocation || weatherProvider.isLoading) {
                return const LoadingShimmer();
              }

              if (weatherProvider.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${weatherProvider.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                weatherProvider.clearError();
                              },
                              child: const Text('Clear'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                weatherProvider.retryLastSearch();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (weatherProvider.currentWeather == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 48,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search for a city to see weather information',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    WeatherCard(weather: weatherProvider.currentWeather!),
                    const SizedBox(height: 24),
                    if (weatherProvider.forecast != null)
                      ForecastList(forecasts: weatherProvider.forecast!),
                  ],
                ),
              );
            },
          ),
          if (_isSearching)
            Consumer<CitySearchProvider>(
              builder: (context, citySearchProvider, child) {
                if (citySearchProvider.suggestions.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  top: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.indigo,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: citySearchProvider.suggestions.length,
                      itemBuilder: (context, index) {
                        final city = citySearchProvider.suggestions[index];
                        return ListTile(
                          title: Text(
                            city,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            _searchController.text = city;
                            context
                                .read<WeatherProvider>()
                                .fetchWeatherByCity(city);
                            citySearchProvider.clearSuggestions();
                            setState(() {
                              _isSearching = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
