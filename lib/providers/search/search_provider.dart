import 'package:flutter/cupertino.dart';
import 'package:weather_app/data/model/search_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';

class SearchProvider  with ChangeNotifier{
  WeatherRepo repo;
  List<SearchModel> items = [];
  bool loading = false;

  SearchProvider(this.repo);

  searchRegion(String city) async {
    loading = true;
    notifyListeners();
   items = await repo.searchRegions(city);
   loading = false;
   notifyListeners();
  }
}