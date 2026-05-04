// import 'package:flutter/material.dart';
// import 'package:weather_app/data/model/hour_model.dart';
//
// class ItemHourlyUpdate extends StatelessWidget {
//   final HourModel hour;
//   const ItemHourlyUpdate({super.key, required this.hour});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Image.network(hour.condition?.icon?.replaceFirst('//', 'https://')?? ''),
//           Text('${hour.tempC}C'),
//           Text(hour.time??'',style: Theme.of(context).textTheme.bodySmall,)
//         ]
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/data/model/hour_model.dart';

class ItemHourlyUpdate extends StatelessWidget {
  final HourModel hour;

  const ItemHourlyUpdate({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    final time = hour.time?.split(' ').last ?? '';

    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          Image.network(
            hour.condition?.icon?.replaceFirst('//', 'https://') ?? '',
            width: 50,
            height: 50,
          ),

          Text(
            "${hour.tempC}°C",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}