import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';

import 'package:libertypaints/model/MyOfferModel.dart';
class MyOfferController extends GetxController{
  List<MyOfferModel> offerList=<MyOfferModel>[].obs;
  fetchMyOfferData(String token) async{
    final res=await http.get(Uri.parse("${baseUrl}api/getOffersApi"),
        headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final offerModel=myOfferModelFromJson(res.body);
    if(res.statusCode==200){
      if(offerModel.isNotEmpty){
        offerList.clear();
        offerList.addAll(offerModel);
      }
    }
    else{
      print("My Offer Data Not fetch ");
    }
  }
}