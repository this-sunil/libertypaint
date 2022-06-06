// To parse this JSON data, do
//
//     final redeemHistoryModel = redeemHistoryModelFromJson(jsonString);

import 'dart:convert';

RedeemHistoryModel redeemHistoryModelFromJson(String str) =>
    RedeemHistoryModel.fromJson(json.decode(str));

String redeemHistoryModelToJson(RedeemHistoryModel data) =>
    json.encode(data.toJson());

class RedeemHistoryModel {
  RedeemHistoryModel({
    required this.redeemrequest,
  });

  List<Redeemrequest> redeemrequest;

  factory RedeemHistoryModel.fromJson(Map<String, dynamic> json) =>
      RedeemHistoryModel(
        redeemrequest: List<Redeemrequest>.from(
            json["redeemrequest"].map((x) => Redeemrequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "redeemrequest":
            List<dynamic>.from(redeemrequest.map((x) => x.toJson())),
      };
}

class Redeemrequest {
  Redeemrequest({
    required this.points,
    required this.requestStatus,
    required this.date,
    required this.time,
  });

  int points;
  int requestStatus;
  String date;
  String time;

  factory Redeemrequest.fromJson(Map<String, dynamic> json) => Redeemrequest(
        points: json["points"],
        requestStatus: json["request_status"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "points": points,
        "request_status": requestStatus,
        "date": date,
        "time": time,
      };
}
