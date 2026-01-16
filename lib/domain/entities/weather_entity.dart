import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  const WeatherEntity({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  @override
  List<Object?> get props => [date, temperature, description, icon];
}
