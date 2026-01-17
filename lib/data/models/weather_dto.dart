import '../../domain/entities/weather_entity.dart';

class WeatherDto {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  WeatherDto({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

 
  factory WeatherDto.fromHourJson(Map<String, dynamic> json) {
    final condition = json['condition'] as Map<String, dynamic>;

    return WeatherDto(
      date: DateTime.parse(json['time'] as String),
      temperature: (json['temp_c'] as num).toDouble(),
      description: condition['text'] ?? '',
      icon: condition['icon'] ?? '',
    );
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      date: date,
      temperature: temperature,
      description: description,
      icon: icon,
    );
  }
}

class ForecastResponseDto {
  final List<WeatherDto> forecasts;

  ForecastResponseDto({required this.forecasts});

  factory ForecastResponseDto.fromJson(Map<String, dynamic> json) {
    final forecast = json['forecast'] as Map<String, dynamic>;
    final forecastDays = forecast['forecastday'] as List;

    final List<WeatherDto> allForecasts = [];

    for (final day in forecastDays) {
      final hours = day['hour'] as List;
      for (final hour in hours) {
        allForecasts.add(WeatherDto.fromHourJson(hour));
      }
    }

    return ForecastResponseDto(forecasts: allForecasts);
  }
}
