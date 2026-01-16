import 'package:equatable/equatable.dart';

import '../../domain/entities/weather_entity.dart';

abstract class WeatherState extends Equatable {
  final String selectedCity;

  const WeatherState({required this.selectedCity});

  @override
  List<Object?> get props => [selectedCity];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial({required super.selectedCity});
}

class WeatherLoading extends WeatherState {
  const WeatherLoading({required super.selectedCity});
}

class WeatherLoaded extends WeatherState {
  final List<WeatherEntity> forecasts;

  const WeatherLoaded({
    required super.selectedCity,
    required this.forecasts,
  });

  @override
  List<Object?> get props => [selectedCity, forecasts];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({
    required super.selectedCity,
    required this.message,
  });

  @override
  List<Object?> get props => [selectedCity, message];
}
