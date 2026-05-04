import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/data/model/current_weather_response.dart';
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/data/model/search_model.dart';

class WeatherApi {
  String baseUrl = 'https://api.weatherapi.com/v1';
  
  Future<CurrentWeatherResponse?> getCurrentWeather(String city) async {
    try{
     final res = await http.get(Uri.parse('$baseUrl/current.json?key=daeeb3d372314514a5162453260205&q=$city&aqi=no'));
     final data = jsonDecode(res.body);
     CurrentWeatherResponse response = CurrentWeatherResponse.fromJson(data);
     print("Current Weather Data ===> $data");
     return response;
    }catch (e){
      print(e);
    }
    return null;
  }

  Future<List<ForecastdayModel>> getForecast(String city, int days) async {
    try{
      final res = await http.get(Uri.parse('$baseUrl/forecast.json?key=daeeb3d372314514a5162453260205&q=$city&days=$days&aqi=no&alerts=no'));
      final data = jsonDecode(res.body);
      List dataList = data['forecast']['forecastday'];
      List<ForecastdayModel> forecastDay = dataList.map((e) => ForecastdayModel.fromJson(e)).toList();
      print("Current Weather Data ===> $data");
      return forecastDay;
    }catch (e){
      print(e);
    }
    return [];
  }

  Future<List<SearchModel>> searchRegion(String city) async {
    try{
      final res = await http.get(Uri.parse('$baseUrl/search.json?key=daeeb3d372314514a5162453260205&q=$city'));
      List data = jsonDecode(res.body);
      List<SearchModel> items = data.map((e) => SearchModel.fromJson(e)).toList();
      return items;
    }catch(e){
      print(e);
    }
    return [];
  }
}