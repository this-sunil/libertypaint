// To parse this JSON data, do
//
//     final videosModel = videosModelFromJson(jsonString);

import 'dart:convert';

List<VideosModel> videosModelFromJson(String str) => List<VideosModel>.from(json.decode(str).map((x) => VideosModel.fromJson(x)));

String videosModelToJson(List<VideosModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideosModel {
  VideosModel({
    required this.title,
    required this.description,
    required this.videoLink,
  });

  String title;
  String description;
  String videoLink;

  factory VideosModel.fromJson(Map<String, dynamic> json) => VideosModel(
    title: json["title"],
    description: json["description"],
    videoLink: json["video_link"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "video_link": videoLink,
  };
}