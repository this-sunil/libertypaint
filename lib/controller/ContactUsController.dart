import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'dart:convert';
class ContactUsController extends GetxController{
  postContact(String token,String phone,String message) async{
    final resp=await http.post(Uri.parse("${baseUrl}api/contactUsApi"),
        headers: {
          "accept":"application/json",
          'Authorization': 'Bearer $token',
    },body: {
      "mobile":phone, "note":message,
        });
    Map<String,dynamic> maps=jsonDecode(resp.body);
    if(resp.statusCode==200){
      Fluttertoast.showToast(msg: maps["message"]);
    }
    else{
      Fluttertoast.showToast(msg: maps["message"]);
    }
  }
}