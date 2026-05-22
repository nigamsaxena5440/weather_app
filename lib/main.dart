import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/api/weather_api.dart';
import 'package:weather_app/data/repository/weather_repo.dart';
import 'package:weather_app/providers/forecast/forecast_provider.dart';
import 'package:weather_app/providers/home/home_provider.dart';
import 'package:weather_app/providers/main/main_provider.dart';
import 'package:weather_app/providers/search/search_provider.dart';
import 'package:weather_app/providers/weather/weather_provider.dart';
import 'package:weather_app/screens/main/main_screen.dart';
import 'package:weather_app/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FMTCObjectBoxBackend().initialise();

  await FMTCStore('mapStore').manage.create();

  await FMTCStore('weather').manage.create();

  await FMTCStore('radar').manage.create();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (context) => MainProvider()),
          Provider(create: (context) => WeatherApi()),
          Provider(create: (context) => WeatherRepo(context.read<WeatherApi>())),
          ChangeNotifierProvider(create: (context) => HomeProvider(context.read<WeatherRepo>())),
          ChangeNotifierProvider(create: (context) => ForecastProvider(context.read<WeatherRepo>())),
          ChangeNotifierProvider(create: (context) => SearchProvider(context.read<WeatherRepo>())),
          ChangeNotifierProvider(create: (context) => WeatherProvider(context.read<WeatherRepo>())),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      )
    );
  }
}
