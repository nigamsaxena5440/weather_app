import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/forecast/forecast_provider.dart';
import 'package:weather_app/screens/forecast/widgets/items_forecast_day.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Forecast',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28),),
        backgroundColor: Color(0xFF22B1CD),
        centerTitle: true,
      ),
      body: Consumer<ForecastProvider>(
          builder: (context,provider,child){
            return provider.loading? Center(child: CircularProgressIndicator()):
            ListView(
              children: [
                for(var day in provider.forecastday)
                  ItemsForecastDay(forecastday: day)
              ],
            );
          }
      ),
    );
  }
}
