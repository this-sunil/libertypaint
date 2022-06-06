// To parse this JSON data, do
//
//     final moneyHistoryModel = moneyHistoryModelFromJson(jsonString);

import 'dart:convert';

List<MoneyHistoryModel> moneyHistoryModelFromJson(String str) => List<MoneyHistoryModel>.from(json.decode(str).map((x) => MoneyHistoryModel.fromJson(x)));

String moneyHistoryModelToJson(List<MoneyHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MoneyHistoryModel {
  MoneyHistoryModel({
    required this.id,
    required this.qrNumber,
    required this.money,
    required this.date,
    required this.time,
  });

  int id;
  String qrNumber;
  String money;
  String date;
  String time;

  factory MoneyHistoryModel.fromJson(Map<String, dynamic> json) => MoneyHistoryModel(
    id: json["id"],
    qrNumber: json["QrNumber"],
    money: json["money"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "QrNumber": qrNumber,
    "money": money,
    "date": date,
    "time": time,
  };
}
