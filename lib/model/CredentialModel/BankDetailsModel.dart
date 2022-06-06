// To parse this JSON data, do
//
//     final bankDetailsModel = bankDetailsModelFromJson(jsonString);

import 'dart:convert';

BankDetailsModel bankDetailsModelFromJson(String str) => BankDetailsModel.fromJson(json.decode(str));

String bankDetailsModelToJson(BankDetailsModel data) => json.encode(data.toJson());

class BankDetailsModel {
  BankDetailsModel({
    required this.bankName,
    required this.bankAccType,
    required this.bankAccNo,
    required this.bankAccHolderName,
    required this.bankIfsc,
    required this.bankPassbook,
    required this.bankCheckbook,
    required this.upiPin,
  });

  String bankName;
  String bankAccType;
  String bankAccNo;
  String bankAccHolderName;
  String bankIfsc;
  String bankPassbook;
  String bankCheckbook;
  String upiPin;

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) => BankDetailsModel(
    bankName: json["bank_name"]??"",
    bankAccType: json["bank_acc_type"]??"",
    bankAccNo: json["bank_acc_no"]??"",
    bankAccHolderName: json["bank_acc_holder_name"]??"",
    bankIfsc: json["bank_ifsc"]??"",
    bankPassbook: json["bank_passbook"]??"",
    bankCheckbook: json["bank_checkbook"]??"",
    upiPin: json["upi_pin"]??"",
  );

  Map<String, dynamic> toJson() => {
    "bank_name": bankName,
    "bank_acc_type": bankAccType,
    "bank_acc_no": bankAccNo,
    "bank_acc_holder_name": bankAccHolderName,
    "bank_ifsc": bankIfsc,
    "bank_passbook": bankPassbook,
    "bank_checkbook": bankCheckbook,
    "upi_pin": upiPin,
  };
}
