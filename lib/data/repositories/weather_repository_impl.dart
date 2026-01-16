import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WeatherEntity>> getWeatherForecast(String city) async {
    final dtos = await remoteDataSource.getWeatherForecast(city);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
