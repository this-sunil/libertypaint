// To parse this JSON data, do
//
//     final complaintHistoryModel = complaintHistoryModelFromJson(jsonString);

import 'dart:convert';

List<ComplaintHistoryModel> complaintHistoryModelFromJson(String str) => List<ComplaintHistoryModel>.from(json.decode(str).map((x) => ComplaintHistoryModel.fromJson(x)));

String complaintHistoryModelToJson(List<ComplaintHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComplaintHistoryModel {
  ComplaintHistoryModel({
    required this.id,
    required this.error,
    required this.detail,
    required this.description,
    required this.image,
    required this.date,
  });

  int id;
  String error;
  String detail;
  String description;
  String image;
  String date;

  factory ComplaintHistoryModel.fromJson(Map<String, dynamic> json) => ComplaintHistoryModel(
    id: json["id"],
    error: json["error"],
    detail: json["detail"],
    description: json["description"] !=null? json["description"]:"",
    image: json["image"] !=null?json["image"]:"",
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "error": error,
    "detail": detail,
    "description": description,
    "image": image,
    "date": date,
  };
}
