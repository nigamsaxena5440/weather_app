import 'package:weather_app/data/model/current_model.dart';
import 'package:weather_app/data/model/location_model.dart';

class CurrentWeatherResponse {
  LocationModel location;
  CurrentModel current;
  
  CurrentWeatherResponse(this.location,this.current);
  
  factory CurrentWeatherResponse.fromJson(json) => CurrentWeatherResponse(
    LocationModel.fromJson(json['location']),
    CurrentModel.fromJson(json['current'])
  );
}