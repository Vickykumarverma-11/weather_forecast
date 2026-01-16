import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class CitySelected extends WeatherEvent {
  final String city;

  const CitySelected(this.city);

  @override
  List<Object?> get props => [city];
}

class FetchForecast extends WeatherEvent {
  final String city;

  const FetchForecast(this.city);

  @override
  List<Object?> get props => [city];
}
