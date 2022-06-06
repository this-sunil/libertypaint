// To parse this JSON data, do
//
//     final mainProfileUpdate = mainProfileUpdateFromJson(jsonString);

import 'dart:convert';

MainProfileUpdateModel mainProfileUpdateModelFromJson(String str) =>
    MainProfileUpdateModel.fromJson(json.decode(str));

String mainProfileUpdateToJson(MainProfileUpdateModel data) =>
    json.encode(data.toJson());

class MainProfileUpdateModel {
  MainProfileUpdateModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.membershipid,
    //this.membershipid,
  });

  String name;
  String email;
  String mobile;
  String membershipid;

  factory MainProfileUpdateModel.fromJson(Map<String, dynamic> json) =>
      MainProfileUpdateModel(
        name: json["name"]??"",
        email: json["email"] ?? "",
        mobile: json["mobile"] ?? "",
        membershipid: json["membershipid"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "membershipid": membershipid,
      };
}
