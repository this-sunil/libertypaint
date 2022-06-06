import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignUpController extends GetxController{
  List<String> signUpToken=<String>[].obs;
  fetchSignUpData(String name,String mobile,String email,String password,String referal,String deviceToken) async{
  SharedPreferences pref=await SharedPreferences.getInstance();
    final resp=await http.post(Uri.parse("${baseUrl}api/userReisterApi"),headers: {
      "accept":"application/json",
    },
    body: {
      "name":name,
      "mobile":mobile,
      "email":email,
      "password":password,
      "referral_code":referal,
      "device_token":deviceToken,

    },
    );
    Map<String,dynamic> maps=jsonDecode(resp.body);
    if(resp.statusCode==200){
      signUpToken.clear();
      Fluttertoast.showToast(msg: maps["message"]);
      pref.setString("token123", maps["token"]);

      signUpToken.add(maps["token"]);
      print("Token Data ${signUpToken[0]}");
      print("Print signUp Token:${signUpToken[0].toString()}");
    }
    else{
      Fluttertoast.showToast(msg: "${maps["message"]}");
    }
  }
}