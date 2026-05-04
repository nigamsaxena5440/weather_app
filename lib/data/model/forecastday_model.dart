import 'astro_model.dart';
import 'day_model.dart';
import 'hour_model.dart';

class ForecastdayModel {
  String? date;
  int? dateEpoch;
  DayModel? day;
  AstroModel? astro;
  List<HourModel>? hour;

  ForecastdayModel({this.date, this.dateEpoch, this.day, this.astro, this.hour});

  ForecastdayModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateEpoch = json['date_epoch'];
    day = json['day'] != null ? new DayModel.fromJson(json['day']) : null;
    astro = json['astro'] != null ? new AstroModel.fromJson(json['astro']) : null;
    if (json['hour'] != null) {
      hour = <HourModel>[];
      json['hour'].forEach((v) {
        hour!.add(new HourModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['date_epoch'] = this.dateEpoch;
    if (this.day != null) {
      data['day'] = this.day!.toJson();
    }
    if (this.astro != null) {
      data['astro'] = this.astro!.toJson();
    }
    if (this.hour != null) {
      data['hour'] = this.hour!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}