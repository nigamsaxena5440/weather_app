// import 'package:flutter/widgets.dart';
// import 'package:weather_app/data/model/forecastday_model.dart';
// import 'package:weather_app/data/repository/weather_repo.dart';
//
// class ForecastProvider with ChangeNotifier{
//   WeatherRepo repo;
//   List<ForecastdayModel> forecastday = [];
//   bool loading = false;
//
//   ForecastProvider(this.repo){
//     getForecast();
//   }
//
//   getForecast() async{
//     loading = true;
//     notifyListeners();
//     forecastday =  await repo.getForecast('${repo.api}', 14);
//     loading = false;
//     notifyListeners();
//   }
//
// }
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';
import 'package:weather_app/data/api/open_meteo_api.dart';

class ForecastProvider with ChangeNotifier {
  WeatherRepo repo;
  List<ForecastdayModel> forecastday = [];
  bool loading = false;

  final OpenMeteoApi _openMeteo = OpenMeteoApi();

  ForecastProvider(this.repo) {
    getForecast();
  }

  Future<void> getForecast() async {
    loading = true;
    notifyListeners();

    try {
      // Get GPS position (same way HomeProvider does)
      final position = await Geolocator.getCurrentPosition();
      final lat = position.latitude;
      final lon = position.longitude;

      // Call Open-Meteo with real coordinates → 14-day forecast
      forecastday = await _openMeteo.getForecast14Days(lat, lon);

    } catch (e) {
      debugPrint('ForecastProvider error: $e');
      // Fallback: WeatherAPI with coordinates string (only 3 days on free plan)
      try {
        final position = await Geolocator.getCurrentPosition();
        final query = '${position.latitude},${position.longitude}';
        forecastday = await repo.getForecast(query, 3);
      } catch (e2) {
        debugPrint('Fallback also failed: $e2');
      }
    }

    loading = false;
    notifyListeners();
  }
}