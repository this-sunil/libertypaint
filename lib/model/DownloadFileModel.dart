// To parse this JSON data, do
//
//     final downloadFileModel = downloadFileModelFromJson(jsonString);

import 'dart:convert';

DownloadFileModel downloadFileModelFromJson(String str) => DownloadFileModel.fromJson(json.decode(str));

String downloadFileModelToJson(DownloadFileModel data) => json.encode(data.toJson());

class DownloadFileModel {
  DownloadFileModel({
    required this.file,
    required this.status,
  });

  String file;
  String status;

  factory DownloadFileModel.fromJson(Map<String, dynamic> json) => DownloadFileModel(
    file: json["file"]??"",
    status: json["status"]??"",
  );

  Map<String, dynamic> toJson() => {
    "file": file,
    "status": status,
  };
}
