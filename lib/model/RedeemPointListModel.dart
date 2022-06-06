// To parse this JSON data, do
//
//     final redeemPointListModel = redeemPointListModelFromJson(jsonString);

import 'dart:convert';

List<RedeemPointListModel> redeemPointListModelFromJson(String str) => List<RedeemPointListModel>.from(json.decode(str).map((x) => RedeemPointListModel.fromJson(x)));

String redeemPointListModelToJson(List<RedeemPointListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RedeemPointListModel {
  RedeemPointListModel({
    required this.listId,
    required this.points,
    required this.money,
  });

  int listId;
  int points;
  String money;

  factory RedeemPointListModel.fromJson(Map<String, dynamic> json) => RedeemPointListModel(
    listId: json["ListId"],
    points: json["Points"],
    money: json["Money"],
  );

  Map<String, dynamic> toJson() => {
    "ListId": listId,
    "Points": points,
    "Money": money,
  };
}
