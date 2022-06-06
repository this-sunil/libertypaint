import 'dart:convert';

UserPontModel userPontModelFromJson(String str) => UserPontModel.fromJson(json.decode(str));

String userPontModelToJson(UserPontModel data) => json.encode(data.toJson());

class UserPontModel {
  UserPontModel({
    this.message,
    this.walletpoints,
  });

  String? message;
  int? walletpoints;

  factory UserPontModel.fromJson(Map<String, dynamic> json) => UserPontModel(
    message: json["message"],
    walletpoints: json["walletpoints"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "walletpoints": walletpoints,
  };
}
