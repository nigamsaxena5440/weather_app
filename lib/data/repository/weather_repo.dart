import 'package:weather_app/data/api/weather_api.dart';
import 'package:weather_app/data/model/current_weather_response.dart';
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/data/model/search_model.dart';

class WeatherRepo {
  WeatherApi api;

  WeatherRepo(this.api);

  Future<CurrentWeatherResponse?> getCurrentWeather(String city) async {
   CurrentWeatherResponse? response =  await  api.getCurrentWeather(city);
   return response;
  }

  Future<List<ForecastdayModel>>getForecast(String city, int days) async {
    List<ForecastdayModel> forecastday = await api.getForecast(city, days);
    return forecastday;
  }

  Future<List<SearchModel>>searchRegions(String city) async {
    List<SearchModel> items = await api.searchRegion(city);
    return items;
  }
}