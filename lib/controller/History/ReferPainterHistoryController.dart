import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'dart:convert';

import 'package:libertypaints/model/HistoryModel/ReferPainterHistoryModel.dart';
class ReferPainterHistoryController extends GetxController{
  List<ReferPainterHistoryModel> referPainterHistory=<ReferPainterHistoryModel>[].obs;
  fetchReferHistory(String token) async {
    final resp = await http.get(Uri.parse("${baseUrl}api/referralHistory"),
        headers: {
          "accept": "application/json",
          'Authorization': 'Bearer $token',
        });

    final maps=referPainterHistoryModelFromJson(resp.body);

    if (resp.statusCode == 200) {
      referPainterHistory.clear();

       if(maps.isNotEmpty) {
         referPainterHistory.addAll(maps);
      }

    }
    else {
      //Fluttertoast.showToast(msg: "failed");
    }
  }
}