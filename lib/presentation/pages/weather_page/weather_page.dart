import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:weather/domain/entities/location.dart';
import 'package:weather/domain/entities/weather.dart';
import 'package:weather/domain/failure.dart';
import 'package:weather/domain/result.dart';
import 'package:weather/domain/usecases/get_current_weather.dart';
import 'package:weather/presentation/app_colors.dart';
import 'package:weather/presentation/pages/locations_page/locations_page.dart';
import 'package:weather/presentation/pages/weather_page/failure_info.dart';
import 'package:weather/presentation/pages/weather_page/sunrise_sunset/sunrise_sunset.dart';
import 'package:weather/presentation/pages/weather_page/weather/weather_header.dart';
import 'package:weather/presentation/pages/weather_page/header_label.dart';
import 'package:weather/presentation/pages/weather_page/forecast/daily_forecast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/injection.dart' as di;

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    super.key,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final GetCurrentWeather _getCurrentWeather = di.locator<GetCurrentWeather>();

  // default city
  String currentCityName = 'brest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primmaryBackgroundColor,
      body: AsyncBuilder<Result<Weather, Failure>>(
        future: _getWeather(currentCityName),
        waiting: (context) => _wetherLoading(),
        builder: (context, data) => _buildWeather(data!),
      ),
    );
  }

  Future<Result<Weather, Failure>> _getWeather(String cityName) {
    return _getCurrentWeather.execute(cityName);
  }

  Widget _buildWeather(Result<Weather, Failure> weatherResult) {
    if (weatherResult.isSuccess) {
      final weather = weatherResult.result!;

      return _weatherHasData(weather);
    } else {
      final failure = weatherResult.failure!;

      return _weatherError(failure);
    }
  }

  Widget _wetherLoading() {
    return const SpinKitFadingCircle(color: AppColors.primaryTextColor);
  }

  Widget _weatherHasData(Weather weather) {
    return RefreshIndicator(
      onRefresh: _pageRefresh,
      color: AppColors.secondaryTextColor,
      backgroundColor: AppColors.secondaryBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherHeader(
              weather: weather,
              locationOnPressed: () => _locationButtonPressed(context),
            ),
            const HeaderLabel(label: 'Forecast'),
            DailyForecast(cityName: currentCityName),
            const HeaderLabel(label: 'Sunrise and sunset'),
            SunriseSunset(sys: weather.sys),
          ],
        ),
      ),
    );
  }

  Widget _weatherError(Failure failure) {
    return FailureInfo(failure: failure);
  }

  Future<void> _locationButtonPressed(BuildContext context) async {
    var location = await Navigator.push<Location>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationsPage(),
      ),
    );

    if (!mounted || location == null) {
      return;
    }

    setState(() => currentCityName = location.cityName);
  }

  Future<void> _pageRefresh() async => setState(() {});
}
