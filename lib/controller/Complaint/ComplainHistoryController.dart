import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/ComplaintModel/ComplaintHistoryModel.dart';
class ComplainHistoryController extends GetxController{
  List<ComplaintHistoryModel> complainList=<ComplaintHistoryModel>[].obs;
  fetchComplainHistory(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}api/complainHistory"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final complainHistory=complaintHistoryModelFromJson(resp.body);
    if(resp.statusCode==200){
     if(complainHistory.isNotEmpty){
       complainList.clear();
       complainList.addAll(complainHistory);
       print("History Complaint ${resp.body}");
     }
    }
    else{
      print("server failed History Complaint ${resp.statusCode}");
    }
  }
}