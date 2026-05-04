import 'package:flutter/material.dart';
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/screens/forecast/widgets/item_hourly_update.dart';

class ItemsForecastDay extends StatelessWidget {
  final ForecastdayModel forecastday;

  const ItemsForecastDay({super.key, required this.forecastday});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF22B1CD), Color(0xFF86B1C3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📅 Date
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      forecastday.date ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      forecastday.day?.condition?.text ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 🌡 Weather Details
              _buildRow("Wind", "${forecastday.day?.maxwindKph ?? 0} km/h"),
              _buildRow("Humidity", "${forecastday.day?.avghumidity ?? 0}%"),
              _buildRow("Max Temp", "${forecastday.day?.maxtempC ?? 0}°"),
              _buildRow("Min Temp", "${forecastday.day?.mintempC ?? 0}°"),
              _buildRow("Sunrise", forecastday.astro?.sunrise ?? ''),
              _buildRow("Sunset", forecastday.astro?.sunset ?? ''),

              const SizedBox(height: 20),

              /// 🌙 Hourly Forecast (Horizontal)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecastday.hour?.length ?? 0,
                  itemBuilder: (context, index) {
                    final hour = forecastday.hour![index];
                    return ItemHourlyUpdate(hour: hour);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable Row Widget
  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}