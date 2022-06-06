import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/AmountModel.dart';

class RedeemPointController extends GetxController {
  List<AmountModel> redeemPointList = <AmountModel>[].obs;
  fetchRedeemPointData(
      String token, String points, String money, BuildContext context) async {
    final resp =
        await http.post(Uri.parse("${baseUrl}api/userRedeemRequest"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "points": points,
      "money": money,
    });
    Map<String, dynamic> result = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      Fluttertoast.showToast(msg: result["message"]);
      if (result["message"] == "success") {
       
      }
    } else {
      Fluttertoast.showToast(msg: result["message"]);
    }
  }
}
