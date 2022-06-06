// To parse this JSON data, do
//
//     final complaintDetailsModel = complaintDetailsModelFromJson(jsonString);

import 'dart:convert';

List<ComplaintDetailsModel> complaintDetailsModelFromJson(String str) => List<ComplaintDetailsModel>.from(json.decode(str).map((x) => ComplaintDetailsModel.fromJson(x)));

String complaintDetailsModelToJson(List<ComplaintDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComplaintDetailsModel {
  ComplaintDetailsModel({
    required this.id,
    required this.complainDetailName,
  });

  int id;
  String complainDetailName;

  factory ComplaintDetailsModel.fromJson(Map<String, dynamic> json) => ComplaintDetailsModel(
    id: json["complain_detail_id"],
    complainDetailName: json["complain_detail_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "complain_detail_name": complainDetailName,
  };
}
