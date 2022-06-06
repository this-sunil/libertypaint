// To parse this JSON data, do
//
//     final moneyRedeemHistoryModel = moneyRedeemHistoryModelFromJson(jsonString);

import 'dart:convert';

MoneyRedeemHistoryModel moneyRedeemHistoryModelFromJson(String str) => MoneyRedeemHistoryModel.fromJson(json.decode(str));

String moneyRedeemHistoryModelToJson(MoneyRedeemHistoryModel data) => json.encode(data.toJson());

class MoneyRedeemHistoryModel {
  MoneyRedeemHistoryModel({
    required this.moneyRedeemrequest,
  });

  List<MoneyRedeemrequest> moneyRedeemrequest;

  factory MoneyRedeemHistoryModel.fromJson(Map<String, dynamic> json) => MoneyRedeemHistoryModel(
    moneyRedeemrequest: List<MoneyRedeemrequest>.from(json["moneyRedeemrequest"].map((x) => MoneyRedeemrequest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "moneyRedeemrequest": List<dynamic>.from(moneyRedeemrequest.map((x) => x.toJson())),
  };
}

class MoneyRedeemrequest {
  MoneyRedeemrequest({
    required this.amount,
    required this.status,
    required this.date,
    required this.time,
  });

  String amount;
  String status;
  String date;
  String time;

  factory MoneyRedeemrequest.fromJson(Map<String, dynamic> json) => MoneyRedeemrequest(
    amount: json["amount"],
    status: json["status"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "status": status,
    "date": date,
    "time": time,
  };
}
