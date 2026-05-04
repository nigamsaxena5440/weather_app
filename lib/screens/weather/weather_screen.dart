// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:weather_app/data/model/search_model.dart';
// import 'package:weather_app/providers/weather/weather_provider.dart';
//
// class WeatherScreen extends StatefulWidget {
//   final SearchModel item;
//   const WeatherScreen({super.key, required this.item});
//
//   @override
//   State<WeatherScreen> createState() => _WeatherScreenState();
// }
//
// class _WeatherScreenState extends State<WeatherScreen> {
//
//   @override
//   void initState() {
//     context.read<WeatherProvider>()
//         .getCurrentWeather(widget.item.name ?? '');
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WeatherProvider>(
//       builder: (context, provider, child) {
//
//         if (provider.loading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         final location = provider.location;
//         final current = provider.current;
//
//         return Scaffold(
//           body: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       const SizedBox(height: 20),
//
//                       Text(
//                         "${location?.name ?? ''}, ${location?.country ?? ''}",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       Text(
//                         current?.condition?.text ?? '',
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   Column(
//                     children: [
//                       Image.network(
//                         current?.condition?.icon
//                             ?.replaceFirst('//', 'https://') ??
//                             '',
//                         width: 120,
//                         height: 120,
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       Text(
//                         "${current?.tempC?.round() ?? 0}°",
//                         style: const TextStyle(
//                           fontSize: 60,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: [
//                         const Divider(color: Colors.white30),
//
//                         Column(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildInfo(
//                                 "Region",
//                                 location?.region ?? ''),
//                             _buildInfo(
//                                 "Wind",
//                                 "${current?.windKph ?? 0} kph"),
//                             _buildInfo(
//                                 "Cloud",
//                                 "${current?.cloud ?? 0}%"),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildInfo(
//                                 "Humidity",
//                                 "${current?.humidity ?? 0}%"),
//                             _buildInfo(
//                                 "Feels Like",
//                                 "${current?.feelslikeC ?? 0}°"),
//                             _buildInfo(
//                                 "UV",
//                                 "${current?.uv ?? 0}"),
//                             _buildInfo("Heat", "${current?.heatindexC ?? 0}~"),
//                             _buildInfo("Pressure", "${current?.pressureIn ?? 0}^"),
//                           ],
//                         ),
//                         const SizedBox(height: 25),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildInfo(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/model/search_model.dart';
import 'package:weather_app/providers/weather/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  final SearchModel item;
  const WeatherScreen({super.key, required this.item});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  @override
  void initState() {
    context.read<WeatherProvider>()
        .getCurrentWeather(widget.item.name ?? '');
    super.initState();
  }
  List<Color> _getWeatherGradient(String? condition) {
    if (condition == null) {
      return [const Color(0xFF0F2027), const Color(0xFF2C5364)];
    }

    final text = condition.toLowerCase();

    if (text.contains("sunny") || text.contains("clear")) {
      return [const Color(0xFFFFA726), const Color(0xFFFFE082)];
    } else if (text.contains("cloud")) {
      return [const Color(0xFF90A4AE), const Color(0xFFCFD8DC)];
    } else if (text.contains("rain") || text.contains("drizzle")) {
      return [const Color(0xFF5C6BC0), const Color(0xFF7986CB)];
    } else if (text.contains("thunder")) {
      return [const Color(0xFF37474F), const Color(0xFF546E7A)];
    } else if (text.contains("snow")) {
      return [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)];
    } else {
      return [const Color(0xFF0F2027), const Color(0xFF2C5364)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {

        if (provider.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final location = provider.location;
        final current = provider.current;
        final conditionText = current?.condition?.text;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getWeatherGradient(conditionText),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),

                      Text(
                        "${location?.name ?? ''}, ${location?.country ?? ''}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        conditionText ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.network(
                        current?.condition?.icon
                            ?.replaceFirst('//', 'https://') ??
                            '',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${current?.tempC?.round() ?? 0}°",
                        style: const TextStyle(
                          fontSize: 80,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  /// 📊 Bottom
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Divider(color: Colors.white30),

                        _buildInfo("Region", location?.region ?? ''),
                        _buildInfo("Wind", "${current?.windKph ?? 0} kph"),
                        _buildInfo("Cloud", "${current?.cloud ?? 0}%"),
                        _buildInfo("Humidity", "${current?.humidity ?? 0}%"),
                        _buildInfo("Feels Like", "${current?.feelslikeC ?? 0}°"),
                        _buildInfo("UV", "${current?.uv ?? 0}"),
                        _buildInfo("Heat", "${current?.heatindexC ?? 0}°"),
                        _buildInfo("Pressure", "${current?.pressureMb ?? 0} mb"),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 📌 Info Row Widget
  Widget _buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
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