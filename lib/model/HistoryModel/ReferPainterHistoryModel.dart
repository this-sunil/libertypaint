// To parse this JSON data, do
//
//     final referPainterHistoryModel = referPainterHistoryModelFromJson(jsonString);

import 'dart:convert';

List<ReferPainterHistoryModel> referPainterHistoryModelFromJson(String str) => List<ReferPainterHistoryModel>.from(json.decode(str).map((x) => ReferPainterHistoryModel.fromJson(x)));

String referPainterHistoryModelToJson(List<ReferPainterHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReferPainterHistoryModel {
  ReferPainterHistoryModel({
    required this.code,
    required this.points,
    required this.money,
    required this.date,
    required this.time,
  });

  String code;
  int points;
  String money;
  String date;
  String time;

  factory ReferPainterHistoryModel.fromJson(Map<String, dynamic> json) => ReferPainterHistoryModel(
    code: json["Code"],
    points: json["Points"],
    money: json["Money"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Points": points,
    "Money": money,
    "date": date,
    "time": time,
  };
}
