import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/model/current_model.dart';
import 'package:weather_app/data/model/current_weather_response.dart';
import 'package:weather_app/data/model/location_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';

// class HomeProvider with ChangeNotifier{
//   WeatherRepo repo;
//   LocationModel? location;
//   CurrentModel? current;
//   bool loading = false;
//
//   HomeProvider(this.repo){
//     getCurrentWeather('${location?.name}');
//   }
//
//   getCurrentWeather(String city) async{
//     loading = true;
//     CurrentWeatherResponse? res = await repo.getCurrentWeather(city);
//     if(res != null){
//       location = res.location;
//       current = res.current;
//     }
//     loading = false;
//     notifyListeners();
//   }
// }
class HomeProvider with ChangeNotifier {

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    }

    return await Geolocator.getCurrentPosition();
  }

  WeatherRepo repo;
  LocationModel? location;
  CurrentModel? current;
  bool loading = false;

  HomeProvider(this.repo) {
    getWeatherByCurrentLocation();
  }

  Future<void> getWeatherByCurrentLocation() async {
    try {
      loading = true;
      notifyListeners();

      final position = await _determinePosition();

      String query = "${position.latitude},${position.longitude}";

      CurrentWeatherResponse? res =
      await repo.getCurrentWeather(query);

      if (res != null) {
        location = res.location;
        current = res.current;
      }

    } catch (e) {
      debugPrint("Location error: $e");
    }

    loading = false;
    notifyListeners();
  }
}