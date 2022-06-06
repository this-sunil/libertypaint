import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:get/get.dart';
import 'package:libertypaints/model/RedeemPointListModel.dart';
class RedeemPointListController extends GetxController{
  List<RedeemPointListModel> redeemPointListModel=<RedeemPointListModel>[].obs;
  fetchRedeemPointList(String token) async{

    final resp=await http.get(Uri.parse("${baseUrl}api/redeemPointsListApi"),
      headers: {
        "accept":"application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final maps=redeemPointListModelFromJson(resp.body);
    print("Response $maps['file']");
    if(resp.statusCode==200){
      redeemPointListModel.clear();
      redeemPointListModel.addAll(maps);
      //Fluttertoast.showToast(msg: "${redeemPointListModel[0]}");
    }
    else{
      Fluttertoast.showToast(msg: resp.body);
    }
  }
}
