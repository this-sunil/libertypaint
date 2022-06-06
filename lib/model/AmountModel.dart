// To parse this JSON data, do
//
//     final amountModel = amountModelFromJson(jsonString);

import 'dart:convert';

AmountModel amountModelFromJson(String str) => AmountModel.fromJson(json.decode(str));

String amountModelToJson(AmountModel data) => json.encode(data.toJson());

class AmountModel {
  AmountModel({
    required this.message,
    required this.errors,
  });

  String message;
  Errors errors;

  factory AmountModel.fromJson(Map<String, dynamic> json) => AmountModel(
    message: json["message"],
    errors: Errors.fromJson(json["errors"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "errors": errors.toJson(),
  };
}

class Errors {
  Errors({
    required this.points,
    required this.money,
  });

  List<String> points;
  List<String> money;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    points: List<String>.from(json["points"].map((x) => x)),
    money: List<String>.from(json["money"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "points": List<dynamic>.from(points.map((x) => x)),
    "money": List<dynamic>.from(money.map((x) => x)),
  };
}
