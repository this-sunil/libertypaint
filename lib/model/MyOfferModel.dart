// To parse this JSON data, do
//
//     final myOfferModel = myOfferModelFromJson(jsonString);

import 'dart:convert';

List<MyOfferModel> myOfferModelFromJson(String str) => List<MyOfferModel>.from(json.decode(str).map((x) => MyOfferModel.fromJson(x)));

String myOfferModelToJson(List<MyOfferModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyOfferModel {
  MyOfferModel({
    required this.title,
    required this.image,
  });

  String title;
  String image;

  factory MyOfferModel.fromJson(Map<String, dynamic> json) => MyOfferModel(
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "image": image,
  };
}