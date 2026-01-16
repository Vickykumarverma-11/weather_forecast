import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_forecast/domain/entities/weather_entity.dart';
import 'package:weather_forecast/domain/repositories/weather_repository.dart';
import 'package:weather_forecast/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:weather_forecast/presentation/bloc/weather_bloc.dart';
import 'package:weather_forecast/presentation/pages/weather_page.dart';

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<List<WeatherEntity>> getWeatherForecast(String city) async {
    return [
      WeatherEntity(
        date: DateTime.now(),
        temperature: 25.0,
        description: 'clear sky',
        icon: '01d',
      ),
    ];
  }
}

void main() {
  testWidgets('WeatherPage displays app bar title', (WidgetTester tester) async {
    final repository = MockWeatherRepository();
    final useCase = GetWeatherForecastUseCase(repository);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => WeatherBloc(getWeatherForecast: useCase),
          child: const WeatherPage(),
        ),
      ),
    );

    expect(find.text('Weather Forecast'), findsOneWidget);
  });

  testWidgets('WeatherPage shows city dropdown', (WidgetTester tester) async {
    final repository = MockWeatherRepository();
    final useCase = GetWeatherForecastUseCase(repository);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => WeatherBloc(getWeatherForecast: useCase),
          child: const WeatherPage(),
        ),
      ),
    );

    expect(find.text('London'), findsOneWidget);
  });
}
