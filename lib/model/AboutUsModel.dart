// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) => AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  AboutUsModel({
    required this.title,
    required this.image,
    required this.description,
  });

  String title;
  String image;
  String description;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
    title: json["title"],
    image: json["image"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "image": image,
    "description": description,
  };
}
