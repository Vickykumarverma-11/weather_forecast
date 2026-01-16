import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecastUseCase {
  final WeatherRepository repository;

  GetWeatherForecastUseCase(this.repository);

  Future<List<WeatherEntity>> call(String city) {
    return repository.getWeatherForecast(city);
  }
}
