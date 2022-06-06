import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/HistoryModel/MoneyRedeemHistoryModel.dart';
class RedeemMoneyHistoryController extends GetxController{
  List<MoneyRedeemHistoryModel> moneyRedeemHistory=<MoneyRedeemHistoryModel>[].obs;
  fetchMoneyRedeemHistory(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}api/moneyRedeemHistoryApi"),headers: {
      "accept":"application/json",
      'Authorization': 'Bearer $token',
    });
    final moneyRedeem=moneyRedeemHistoryModelFromJson(resp.body);
    if(resp.statusCode==200){
      print("Money Redeem :${resp.body}");
      if(moneyRedeem.moneyRedeemrequest.isNotEmpty){
      moneyRedeemHistory.clear();
      for(int i=0;i<moneyRedeem.moneyRedeemrequest.length;i++){
        moneyRedeemHistory.add(moneyRedeem);
      }
      }
    }
    else{
      print("Money Redeem :${resp.statusCode}");
    }
  }
}