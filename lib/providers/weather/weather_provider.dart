import 'package:flutter/cupertino.dart';
import 'package:weather_app/data/model/current_model.dart';
import 'package:weather_app/data/model/location_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';

import '../../data/model/current_weather_response.dart';

class WeatherProvider with ChangeNotifier{
  WeatherRepo repo;
  LocationModel? location;
  CurrentModel? current;
  bool loading = false;

  WeatherProvider(this.repo);

  getCurrentWeather(String city) async{
    loading = true;
    CurrentWeatherResponse? res = await repo.getCurrentWeather(city);
    if(res != null){
      location = res.location;
      current = res.current;
    }
    loading = false;
    notifyListeners();
  }
}