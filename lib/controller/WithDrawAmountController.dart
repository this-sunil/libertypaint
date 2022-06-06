import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
class WithDrawAmountController extends GetxController{
  withdrawAmountData(String token,String amount) async{
    print(amount);
    final resp=await http.post(Uri.parse("${baseUrl}api/withdrawMoneyRequest"),
        body: {
          "amount":amount,
        },
        headers: {
          "accept":"application/json",
          'Authorization': 'Bearer $token',
        }
    );
    final data=jsonDecode(resp.body);
    print("WithDraw Amount ${data["message"]}");
    if(resp.statusCode==200){
      Fluttertoast.showToast(msg: data["message"]);
    }
    else{
      Fluttertoast.showToast(msg: data["message"]);
    }
  }
}