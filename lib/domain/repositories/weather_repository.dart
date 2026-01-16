import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<List<WeatherEntity>> getWeatherForecast(String city);
}
