class WeatherModel {
  final String lastUpdated;
  final int lastUpdatedEpoch;
  final double tempC;
  final double tempF;
  final double feelslikeC;
  final double feelslikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final int isDay;
  final double uv;
  final double gustMph;
  final double gustKph;
  final String locationName;

  WeatherModel({
    required this.lastUpdated,
    required this.lastUpdatedEpoch,
    required this.tempC,
    required this.tempF,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.isDay,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    required this.locationName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      lastUpdated: json['last_updated'] ?? '',
      lastUpdatedEpoch: json['last_updated_epoch'] ?? 0,
      tempC: json['temp_c']?.toDouble() ?? 0.0,
      tempF: json['temp_f']?.toDouble() ?? 0.0,
      feelslikeC: json['feelslike_c']?.toDouble() ?? 0.0,
      feelslikeF: json['feelslike_f']?.toDouble() ?? 0.0,
      windchillC: json['windchill_c']?.toDouble() ?? 0.0,
      windchillF: json['windchill_f']?.toDouble() ?? 0.0,
      heatindexC: json['heatindex_c']?.toDouble() ?? 0.0,
      heatindexF: json['heatindex_f']?.toDouble() ?? 0.0,
      dewpointC: json['dewpoint_c']?.toDouble() ?? 0.0,
      dewpointF: json['dewpoint_f']?.toDouble() ?? 0.0,
      conditionText: json['condition']?['text'] ?? '',
      conditionIcon: 'https:${json['condition']?['icon'] ?? ''}',
      conditionCode: json['condition']?['code'] ?? 0,
      windMph: json['wind_mph']?.toDouble() ?? 0.0,
      windKph: json['wind_kph']?.toDouble() ?? 0.0,
      windDegree: json['wind_degree'] ?? 0,
      windDir: json['wind_dir'] ?? '',
      pressureMb: json['pressure_mb']?.toDouble() ?? 0.0,
      pressureIn: json['pressure_in']?.toDouble() ?? 0.0,
      precipMm: json['precip_mm']?.toDouble() ?? 0.0,
      precipIn: json['precip_in']?.toDouble() ?? 0.0,
      humidity: json['humidity'] ?? 0,
      cloud: json['cloud'] ?? 0,
      isDay: json['is_day'] ?? 0,
      uv: json['uv']?.toDouble() ?? 0.0,
      gustMph: json['gust_mph']?.toDouble() ?? 0.0,
      gustKph: json['gust_kph']?.toDouble() ?? 0.0,
      locationName: json['location_name'] ?? '',
    );
  }
}

class WeatherForecastModel {
  final String date;
  final int dateEpoch;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final double maxWindMph;
  final double maxWindKph;
  final double totalPrecipMm;
  final double totalPrecipIn;
  final double totalSnowCm;
  final double avgVisKm;
  final double avgVisMiles;
  final int avgHumidity;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final double uv;
  final int willItRain;
  final int willItSnow;
  final int chanceOfRain;
  final int chanceOfSnow;

  WeatherForecastModel({
    required this.date,
    required this.dateEpoch,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindMph,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.totalPrecipIn,
    required this.totalSnowCm,
    required this.avgVisKm,
    required this.avgVisMiles,
    required this.avgHumidity,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.uv,
    required this.willItRain,
    required this.willItSnow,
    required this.chanceOfRain,
    required this.chanceOfSnow,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final day = json['day'];
    return WeatherForecastModel(
      date: json['date'] ?? '',
      dateEpoch: json['date_epoch'] ?? 0,
      maxTempC: day['maxtemp_c']?.toDouble() ?? 0.0,
      maxTempF: day['maxtemp_f']?.toDouble() ?? 0.0,
      minTempC: day['mintemp_c']?.toDouble() ?? 0.0,
      minTempF: day['mintemp_f']?.toDouble() ?? 0.0,
      avgTempC: day['avgtemp_c']?.toDouble() ?? 0.0,
      avgTempF: day['avgtemp_f']?.toDouble() ?? 0.0,
      maxWindMph: day['maxwind_mph']?.toDouble() ?? 0.0,
      maxWindKph: day['maxwind_kph']?.toDouble() ?? 0.0,
      totalPrecipMm: day['totalprecip_mm']?.toDouble() ?? 0.0,
      totalPrecipIn: day['totalprecip_in']?.toDouble() ?? 0.0,
      totalSnowCm: day['totalsnow_cm']?.toDouble() ?? 0.0,
      avgVisKm: day['avgvis_km']?.toDouble() ?? 0.0,
      avgVisMiles: day['avgvis_miles']?.toDouble() ?? 0.0,
      avgHumidity: day['avghumidity'] ?? 0,
      conditionText: day['condition']?['text'] ?? '',
      conditionIcon: 'https:${day['condition']?['icon'] ?? ''}',
      conditionCode: day['condition']?['code'] ?? 0,
      uv: day['uv']?.toDouble() ?? 0.0,
      willItRain: day['daily_will_it_rain'] ?? 0,
      willItSnow: day['daily_will_it_snow'] ?? 0,
      chanceOfRain: day['daily_chance_of_rain'] ?? 0,
      chanceOfSnow: day['daily_chance_of_snow'] ?? 0,
    );
  }
}
