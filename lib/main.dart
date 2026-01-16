import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/weather_remote_data_source.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'domain/usecases/get_weather_forecast_usecase.dart';
import 'presentation/bloc/weather_bloc.dart';
import 'presentation/pages/weather_page.dart';

void main() {
  // Simple dependency injection
  final dio = Dio();
  final remoteDataSource = WeatherRemoteDataSourceImpl(dio: dio);
  final repository = WeatherRepositoryImpl(remoteDataSource: remoteDataSource);
  final getWeatherForecastUseCase = GetWeatherForecastUseCase(repository);

  runApp(MyApp(getWeatherForecastUseCase: getWeatherForecastUseCase));
}

class MyApp extends StatelessWidget {
  final GetWeatherForecastUseCase getWeatherForecastUseCase;

  const MyApp({super.key, required this.getWeatherForecastUseCase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => WeatherBloc(getWeatherForecast: getWeatherForecastUseCase),
        child: const WeatherPage(),
      ),
    );
  }
}
