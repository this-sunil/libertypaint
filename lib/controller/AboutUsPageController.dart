import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/AboutUsModel.dart';
class AboutUsPageController extends GetxController{
  List<AboutUsModel> list=<AboutUsModel>[].obs;
  fetchAboutData(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}api/getAboutUsApi"),
    headers: {
      "accept":"application/json",
      'Authorization': 'Bearer $token',
    }
    );
    final data=aboutUsModelFromJson(resp.body);
    if(resp.statusCode==200){
      if(resp.body.isNotEmpty){
        list.clear();
        list.add(data);
      }
    }
    else{
      print("About US ${resp.statusCode}");
    }
  }
}