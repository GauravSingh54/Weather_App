import 'package:flutter/material.dart';
import '../models/weather_model.dart' as weather_model;

class WeatherCard extends StatelessWidget {
  final weather_model.WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  Widget _buildWeatherInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.3)
            : const Color.fromARGB(255, 0, 81, 255).withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                weather.locationName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Last Updated: ${weather.lastUpdated}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 8),
              Image.network(
                weather.conditionIcon,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                '${weather.tempC.toStringAsFixed(1)}°C (${weather.tempF.toStringAsFixed(1)}°F)',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                'Feels like: ${weather.feelslikeC.toStringAsFixed(1)}°C (${weather.feelslikeF.toStringAsFixed(1)}°F)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              Text(
                weather.conditionText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherInfo(
                    context,
                    'Humidity',
                    '${weather.humidity}%',
                    Icons.water_drop,
                  ),
                  _buildWeatherInfo(
                    context,
                    'Wind',
                    '${weather.windKph.toStringAsFixed(1)} km/h ${weather.windDir}',
                    Icons.air,
                  ),
                  _buildWeatherInfo(
                    context,
                    'Pressure',
                    '${weather.pressureMb.toStringAsFixed(1)} hPa',
                    Icons.speed,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherInfo(
                    context,
                    'Precipitation',
                    '${weather.precipMm.toStringAsFixed(1)} mm',
                    Icons.water,
                  ),
                  _buildWeatherInfo(
                    context,
                    'UV Index',
                    weather.uv.toStringAsFixed(1),
                    Icons.wb_sunny,
                  ),
                  _buildWeatherInfo(
                    context,
                    'Cloud Cover',
                    '${weather.cloud}%',
                    Icons.cloud,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherInfo(
                    context,
                    'Wind Gust',
                    '${weather.gustKph.toStringAsFixed(1)} km/h',
                    Icons.air,
                  ),
                  _buildWeatherInfo(
                    context,
                    'Dew Point',
                    '${weather.dewpointC.toStringAsFixed(1)}°C',
                    Icons.water_drop,
                  ),
                  _buildWeatherInfo(
                    context,
                    'Heat Index',
                    '${weather.heatindexC.toStringAsFixed(1)}°C',
                    Icons.thermostat,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
