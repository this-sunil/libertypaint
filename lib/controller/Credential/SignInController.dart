import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/view/main_Screen.dart';

class SignInController extends GetxController {
  List<String> tokens = <String>[].obs;
  fetchSignInData(String mobile, String password, BuildContext context,String deviceToken) async {
    final resp = await http.post(
      Uri.parse("${baseUrl}api/loginUserApi"),
      headers: {
        "accept": "application/json",
      },
      body: {
        "mobile": mobile,
        "password": password,
        "device_token":deviceToken,
      },
    );
    Map<String, dynamic> result = jsonDecode(resp.body);

    if (resp.statusCode == 200) {
      tokens.clear();
      Fluttertoast.showToast(msg: result["message"]);
      tokens.add(result["token"]);
      print("Sign In Controller:$tokens");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(token: result["token"])));
    } else {
      Fluttertoast.showToast(msg: result["message"]);
    }
  }
}
