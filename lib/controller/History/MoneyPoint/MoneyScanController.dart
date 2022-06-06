import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
class MoneyScanController extends GetxController{
  List<String> moneyPoint=<String>[].obs;
  fetchScanMoney(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}api/userMoneyBalance"),
      headers: {
        "accept":"application/json",
        'Authorization': 'Bearer $token',
      },
    );
    Map<String,dynamic> map=jsonDecode(resp.body);
    if(resp.statusCode==200){
      moneyPoint.clear();
     for(int i=0;i<map.length;i++){
       moneyPoint.add(map["walletMoney"]);
     }
      print(map["message"]);
    }
    else{
      print(map["message"]);
    }
  }
}