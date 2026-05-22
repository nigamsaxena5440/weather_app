import 'package:flutter/material.dart';
import 'package:weather_app/data/model/hour_model.dart';

class ItemHourlyUpdate extends StatelessWidget {
  final HourModel hour;
  final Color accent;

  const ItemHourlyUpdate({
    super.key,
    required this.hour,
    this.accent = const Color(0xFF22B1CD),
  });

  bool _isNight(String? time) {
    if (time == null) return false;
    try {
      // time format: "2024-05-20 21:00"
      final timePart = time.split(' ').last;
      final hour = int.parse(timePart.split(':').first);
      return hour >= 20 || hour < 6; // night = 8PM to 6AM
    } catch (_) {
      return false;
    }
  }

  String _conditionToEmoji(String? condition, bool isNight) {
    if (condition == null) return isNight ? '🌙' : '🌤️';
    final t = condition.toLowerCase();

    if (t.contains('thunder')) return '⛈️';
    if (t.contains('snow shower')) return '🌨️';
    if (t.contains('snow')) return '❄️';
    if (t.contains('rain shower') || t.contains('drizzle')) {
      return isNight ? '🌧️' : '🌦️';
    }
    if (t.contains('rain')) return '🌧️';
    if (t.contains('fog') || t.contains('mist')) return '🌫️';
    if (t.contains('overcast')) return '☁️';
    if (t.contains('cloud')) return isNight ? '☁️' : '⛅';
    if (t.contains('clear') || t.contains('sunny')) {
      return isNight ? '🌙' : '☀️';
    }
    if (t.contains('partly')) return isNight ? '🌛' : '⛅';

    return isNight ? '🌙' : '🌤️';
  }

  @override
  Widget build(BuildContext context) {
    final time = hour.time?.split(' ').last ?? '';
    final night = _isNight(hour.time);

    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        // Slightly different tint for night hours
        color: night
            ? Colors.indigo.withOpacity(0.15)
            : Colors.white.withOpacity(0.08),
        border: Border.all(
          color: night
              ? Colors.indigo.withOpacity(0.25)
              : Colors.white.withOpacity(0.11),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Time
          Text(
            time,
            style: TextStyle(
              color: night
                  ? Colors.indigo.shade200
                  : Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Emoji
          Text(
            _conditionToEmoji(hour.condition?.text, night),
            style: const TextStyle(fontSize: 28),
          ),

          // Temperature
          Text(
            "${hour.tempC?.round() ?? 0}°",
            style: TextStyle(
              color: night ? Colors.indigo.shade200 : accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}