import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_weather_forecast_usecase.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherForecastUseCase getWeatherForecast;

  WeatherBloc({required this.getWeatherForecast})
      : super(const WeatherInitial(selectedCity: 'London')) {
    on<CitySelected>(_onCitySelected);
    on<FetchForecast>(_onFetchForecast);
  }

  Future<void> _onCitySelected(
    CitySelected event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading(selectedCity: event.city));
    await _fetchWeather(event.city, emit);
  }

  Future<void> _onFetchForecast(
    FetchForecast event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading(selectedCity: event.city));
    await _fetchWeather(event.city, emit);
  }

  Future<void> _fetchWeather(String city, Emitter<WeatherState> emit) async {
    try {
      final forecasts = await getWeatherForecast(city);
      emit(WeatherLoaded(selectedCity: city, forecasts: forecasts));
    } catch (e) {
      emit(WeatherError(
        selectedCity: city,
        message: 'Failed to fetch weather data. Please try again.',
      ));
    }
  }
}
