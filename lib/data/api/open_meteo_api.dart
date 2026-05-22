import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/data/model/day_model.dart';
import 'package:weather_app/data/model/hour_model.dart';
import 'package:weather_app/data/model/astro_model.dart';

import '../model/condition_Model.dart';

class OpenMeteoApi {
  // First geocode the city using WeatherAPI search, then call Open-Meteo
  Future<List<ForecastdayModel>> getForecast14Days(
      double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=$lat&longitude=$lon'
            '&daily=weathercode,temperature_2m_max,temperature_2m_min,'
            'windspeed_10m_max,precipitation_sum,sunrise,sunset,uv_index_max'
            '&hourly=temperature_2m,weathercode'
            '&timezone=auto'
            '&forecast_days=14',
      );

      final res = await http.get(url);
      final data = jsonDecode(res.body);

      final daily = data['daily'];
      final hourly = data['hourly'];
      final List<String> dates = List<String>.from(daily['time']);

      return List.generate(dates.length, (i) {
        // Build hourly list for this day (24 hours each)
        final startHour = i * 24;
        final hours = List.generate(24, (h) {
          final idx = startHour + h;
          return HourModel(
            time: '${dates[i]} ${hourly['time'][idx].split('T').last}',
            tempC: (hourly['temperature_2m'][idx] as num).toDouble(),
            condition: ConditionModel(
              text: _wmoToText(hourly['weathercode'][idx]),
              icon: '',   // ← just empty string, emoji handles display
            ),
          );
        });

        return ForecastdayModel(
          date: dates[i],
          day: DayModel(
            maxtempC: (daily['temperature_2m_max'][i] as num).toDouble(),
            mintempC: (daily['temperature_2m_min'][i] as num).toDouble(),
            maxwindKph: (daily['windspeed_10m_max'][i] as num).toDouble(),
            avghumidity: (daily['precipitation_sum'][i] as num).toDouble(),
            condition: ConditionModel(
              text: _wmoToText(daily['weathercode'][i]),
              icon: '',   // ← empty string
            ),
            uv: (daily['uv_index_max'][i] as num).toDouble(),
          ),
          astro: AstroModel(
            sunrise: _formatTime(daily['sunrise'][i]),
            sunset: _formatTime(daily['sunset'][i]),
          ),
          hour: hours,
        );
      });
    } catch (e) {
      print('OpenMeteo error: $e');
      return [];
    }
  }

  String _formatTime(String iso) {
    // "2024-05-20T05:41" → "05:41 AM"
    try {
      final time = iso.split('T').last;
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final min = parts[1];
      final suffix = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:$min $suffix';
    } catch (_) {
      return iso;
    }
  }

  String _wmoToText(int code) {
    if (code == 0) return 'Clear';
    if (code <= 2) return 'Partly Cloudy';
    if (code == 3) return 'Overcast';
    if (code <= 49) return 'Foggy';
    if (code <= 59) return 'Drizzle';
    if (code <= 69) return 'Rain';
    if (code <= 79) return 'Snow';
    if (code <= 82) return 'Rain Showers';
    if (code <= 86) return 'Snow Showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  String _wmoToIcon(int code) {
    if (code == 0) return 'https://cdn.weatherapi.com/weather/64x64/day/113.png';
    if (code <= 2) return 'https://cdn.weatherapi.com/weather/64x64/day/116.png';
    if (code == 3) return 'https://cdn.weatherapi.com/weather/64x64/day/119.png';
    if (code <= 49) return 'https://cdn.weatherapi.com/weather/64x64/day/143.png';
    if (code <= 59) return 'https://cdn.weatherapi.com/weather/64x64/day/266.png';
    if (code <= 69) return 'https://cdn.weatherapi.com/weather/64x64/day/308.png';
    if (code <= 79) return 'https://cdn.weatherapi.com/weather/64x64/day/338.png';
    if (code <= 82) return 'https://cdn.weatherapi.com/weather/64x64/day/353.png';
    if (code <= 86) return 'https://cdn.weatherapi.com/weather/64x64/day/368.png';
    if (code <= 99) return 'https://cdn.weatherapi.com/weather/64x64/day/389.png';
    return 'https://cdn.weatherapi.com/weather/64x64/day/113.png';
  }
}