// To parse this JSON data, do
//
//     final persnalDetailUpdate = persnalDetailUpdateFromJson(jsonString);

import 'dart:convert';

PersnalDetailUpdate persnalDetailUpdateFromJson(String str) =>
    PersnalDetailUpdate.fromJson(json.decode(str));

String persnalDetailUpdateToJson(PersnalDetailUpdate data) =>
    json.encode(data.toJson());

class PersnalDetailUpdate {
  PersnalDetailUpdate({
    this.name,
    this.email,
    this.mobile,
  });

  String? name;
  String? email;
  String? mobile;

  factory PersnalDetailUpdate.fromJson(Map<String, dynamic> json) =>
      PersnalDetailUpdate(
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        mobile: json["mobile"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
      };
}
