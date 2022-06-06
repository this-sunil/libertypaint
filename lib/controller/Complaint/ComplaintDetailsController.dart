import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'dart:convert';

import 'package:libertypaints/model/ComplaintModel/ComplaintDetailsModel.dart';
class ComplaintDetailsController extends GetxController{
  List<ComplaintDetailsModel> complaintList=<ComplaintDetailsModel>[].obs;
  fetchComplaintDetailsData(String token,int id) async{

    print("id $token $id");
    final resp=await http.get(Uri.parse("${baseUrl}api/getComplainDetailsListApi/$id"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //Map<String,dynamic> map=jsonDecode(resp.body);
    final complaintListData=complaintDetailsModelFromJson(resp.body);
    if(resp.statusCode==200){
      if(complaintListData.isNotEmpty){
        complaintList.clear();
        complaintList.addAll(complaintListData);
      }
      print("Complaint  Details Response"+resp.body);
    }
    else{
      print("Complaint  Details Response Failed"+resp.statusCode.toString());
    }
  }
}