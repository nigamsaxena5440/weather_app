import 'package:flutter/widgets.dart';
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';

class ForecastProvider with ChangeNotifier{
  WeatherRepo repo;
  List<ForecastdayModel> forecastday = [];
  bool loading = false;

  ForecastProvider(this.repo){
    getForecast();
  }

  getForecast() async{
    loading = true;
    notifyListeners();
    forecastday =  await repo.getForecast('${repo.api}', 10);
    loading = false;
    notifyListeners();
  }

}
