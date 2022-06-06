import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'dart:convert';
class MyComplaintController extends GetxController{
  fetchData(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}"),
     headers: {
       'Accept': 'application/json',
       'Authorization': 'Bearer $token',
     },
    );

    Map<String,dynamic> map=jsonDecode(resp.body);
    if(resp.statusCode==200){
      print("New Complaint Response"+resp.body);
    }
    else{
      print("Response Failed"+resp.statusCode.toString());
    }
  }
}