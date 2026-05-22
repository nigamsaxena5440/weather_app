import 'package:flutter/material.dart';
import 'package:weather_app/data/model/search_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';

class SearchProvider with ChangeNotifier {
  WeatherRepo repo;
  List<SearchModel> items = [];
  bool loading = false;

  SearchProvider(this.repo);

  Future<void> searchRegion(String query) async {
    if (query.trim().isEmpty) return;

    loading = true;
    notifyListeners();

    try {
      // Search with India bias first
      List<SearchModel> results = await repo.searchRegions('$query, India');

      // If no results found, search globally as fallback
      if (results.isEmpty) {
        results = await repo.searchRegions(query);
      }

      // Sort: India results first, then rest
      results.sort((a, b) {
        final aIsIndia = (a.country?.toLowerCase() == 'india') ? 0 : 1;
        final bIsIndia = (b.country?.toLowerCase() == 'india') ? 0 : 1;
        return aIsIndia.compareTo(bIsIndia);
      });

      items = results;
    } catch (e) {
      debugPrint('Search error: $e');
      items = [];
    }

    loading = false;
    notifyListeners();
  }

  void clearResults() {
    items = [];
    notifyListeners();
  }
}