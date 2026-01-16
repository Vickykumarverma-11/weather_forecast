import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/weather_entity.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  static const List<String> cities = ['London', 'Delhi', 'New York'];

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    // Auto-fetch weather for the default city on app load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<WeatherBloc>();
      bloc.add(FetchForecast(bloc.state.selectedCity));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _CitySelector(cities: WeatherPage.cities),
            Expanded(child: _ForecastContent()),
          ],
        ),
      ),
    );
  }
}

/// Enhanced city selector with gradient background
class _CitySelector extends StatelessWidget {
  final List<String> cities;

  const _CitySelector({required this.cities});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF7B68EE)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            // City dropdown
            BlocBuilder<WeatherBloc, WeatherState>(
              buildWhen: (previous, current) =>
                  previous.selectedCity != current.selectedCity,
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF4A90E2),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: state.selectedCity,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF4A90E2),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                              items: cities.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              onChanged: (city) {
                                if (city != null) {
                                  context.read<WeatherBloc>().add(CitySelected(city));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Forecast content with state handling
class _ForecastContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          return const _ShimmerLoading();
        }

        if (state is WeatherLoading) {
          return const _ShimmerLoading();
        }

        if (state is WeatherError) {
          return _ErrorState(
            message: state.message,
            onRetry: () {
              context.read<WeatherBloc>().add(FetchForecast(state.selectedCity));
            },
          );
        }

        if (state is WeatherLoaded) {
          if (state.forecasts.isEmpty) {
            return const _EmptyState(message: 'No forecast data available');
          }
          return _ForecastList(forecasts: state.forecasts);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Shimmer loading effect
class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Icon placeholder
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text placeholders
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 120,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Temperature placeholder
                    Container(
                      width: 50,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Empty state with icon and message
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({this.message = 'Select a city to view forecast'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wb_sunny_outlined,
                size: 48,
                color: Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state with icon, message, and retry button
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off,
                size: 48,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Forecast list with lazy loading
class _ForecastList extends StatefulWidget {
  final List<WeatherEntity> forecasts;

  const _ForecastList({required this.forecasts});

  @override
  State<_ForecastList> createState() => _ForecastListState();
}

class _ForecastListState extends State<_ForecastList> {
  static const int _initialLoadCount = 10;
  static const int _loadMoreCount = 8;

  final ScrollController _scrollController = ScrollController();
  int _displayedItemCount = _initialLoadCount;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_ForecastList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset when forecasts change (city changed)
    if (oldWidget.forecasts != widget.forecasts) {
      setState(() {
        _displayedItemCount = _initialLoadCount;
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_displayedItemCount >= widget.forecasts.length) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8; // Load more when 80% scrolled

    if (currentScroll >= threshold) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      _isLoadingMore = true;
    });

    // Simulate a small delay for smoother UX
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _displayedItemCount = (_displayedItemCount + _loadMoreCount)
              .clamp(0, widget.forecasts.length);
          _isLoadingMore = false;
        });
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _displayedItemCount.clamp(0, widget.forecasts.length);
    final hasMore = itemCount < widget.forecasts.length;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: itemCount + (hasMore ? 1 : 0), // +1 for loading indicator
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (index == itemCount) {
          return _LoadMoreIndicator(isLoading: _isLoadingMore);
        }

        final forecast = widget.forecasts[index];
        final showDateHeader = index == 0 ||
            !_isSameDay(widget.forecasts[index - 1].date, forecast.date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) _DateHeader(date: forecast.date),
            _ForecastCard(forecast: forecast),
          ],
        );
      },
    );
  }
}

/// Loading indicator for lazy loading
class _LoadMoreIndicator extends StatelessWidget {
  final bool isLoading;

  const _LoadMoreIndicator({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading more...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Scroll for more',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
      ),
    );
  }
}

/// Date header for grouping forecasts by day
class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final isTomorrow = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1;

    String label;
    if (isToday) {
      label = 'Today';
    } else if (isTomorrow) {
      label = 'Tomorrow';
    } else {
      label = DateFormat('EEEE, MMM d').format(date);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual forecast card
class _ForecastCard extends StatelessWidget {
  final WeatherEntity forecast;

  const _ForecastCard({required this.forecast});

  String _getIconUrl(String icon) {
    if (icon.startsWith('//')) {
      return 'https:$icon';
    }
    return icon;
  }

  String _capitalizeDescription(String description) {
    if (description.isEmpty) return '';
    return description[0].toUpperCase() + description.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Weather icon with background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A90E2).withValues(alpha: 0.15),
                    const Color(0xFF7B68EE).withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                _getIconUrl(forecast.icon),
                width: 56,
                height: 56,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.cloud,
                  size: 28,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Time and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeFormat.format(forecast.date),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _capitalizeDescription(forecast.description),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Temperature badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getTemperatureGradient(forecast.temperature),
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _getTemperatureGradient(forecast.temperature)[0]
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${forecast.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getTemperatureGradient(double temp) {
    if (temp <= 0) {
      return [const Color(0xFF667EEA), const Color(0xFF64B5F6)];
    }
    if (temp <= 10) {
      return [const Color(0xFF4FC3F7), const Color(0xFF29B6F6)];
    }
    if (temp <= 20) {
      return [const Color(0xFF26A69A), const Color(0xFF4DB6AC)];
    }
    if (temp <= 30) {
      return [const Color(0xFFFFB74D), const Color(0xFFFFA726)];
    }
    return [const Color(0xFFEF5350), const Color(0xFFE53935)];
  }
}
