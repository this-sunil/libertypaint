import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'dart:convert';

import 'package:libertypaints/model/ComplaintModel/ErrorDetailsModel.dart';
class ErrorDetailsController extends GetxController{
  List<ErrorDetailsModel> errDetails=<ErrorDetailsModel>[].obs;
  fetchErrDetailsData(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}api/errorTypeListApi"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final map=errorDetailsModelFromJson(resp.body);

    if(resp.statusCode==200){
      errDetails.clear();

      errDetails.addAll(map);
      /*for(int i=0;i<map.length;i++){
       // print(map[i]["id"]);
        errDetails.add(map[i]["error_name"]);
        print(errDetails[i]);
      }*/

      print("New Complaint Error Details Response"+resp.body);
    }
    else{
      print("New Complaint Error Details Response Failed"+resp.statusCode.toString());
    }
  }
}