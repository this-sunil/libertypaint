// To parse this JSON data, do
//
//     final kycEditDetailsModel = kycEditDetailsModelFromJson(jsonString);

import 'dart:convert';

KycEditDetailsModel kycEditDetailsModelFromJson(String str) =>
    KycEditDetailsModel.fromJson(json.decode(str));

String kycEditDetailsModelToJson(KycEditDetailsModel data) =>
    json.encode(data.toJson());

class KycEditDetailsModel {
  KycEditDetailsModel({
    this.adharNo,
    this.panNo,
    this.voterId,
    this.drivingLicence,
  });

  dynamic adharNo;
  dynamic panNo;
  dynamic voterId;
  dynamic drivingLicence;

  factory KycEditDetailsModel.fromJson(Map<String, dynamic> json) =>
      KycEditDetailsModel(
        adharNo: json["adhar_no"] ?? "",
        panNo: json["pan_no"] ?? "",
        voterId: json["voter_id"] ?? "",
        drivingLicence: json["driving_licence"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "adhar_no": adharNo,
        "pan_no": panNo,
        "voter_id": voterId,
        "driving_licence": drivingLicence,
      };
}
