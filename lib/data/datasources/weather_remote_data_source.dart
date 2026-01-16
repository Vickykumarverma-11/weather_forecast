import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/weather_dto.dart';

abstract class WeatherRemoteDataSource {
  Future<List<WeatherDto>> getWeatherForecast(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<WeatherDto>> getWeatherForecast(String city) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.forecastEndpoint}',
      queryParameters: {
        'key': ApiConstants.apiKey,
        'q': city,
        'days': 3,
      },
    );

    final forecastResponse = ForecastResponseDto.fromJson(response.data);
    return forecastResponse.forecasts;
  }
}
