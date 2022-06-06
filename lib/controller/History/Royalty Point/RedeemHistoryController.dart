import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/HistoryModel/RedeemHistoryModel.dart';

class RedeemHistoryController extends GetxController {
  List<RedeemHistoryModel> redeemHistoryList = <RedeemHistoryModel>[].obs;
  fetchRedeemHistory(String token) async {
    final resp = await http.get(
      Uri.parse("${baseUrl}api/redeemHistoryApi"),
      headers: {
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final redeemHistoryModel = redeemHistoryModelFromJson(resp.body);
    if (resp.statusCode == 200) {
      if (redeemHistoryModel.redeemrequest.isNotEmpty) {
        print("Redeem History" + resp.body);
        redeemHistoryList.clear();
      for(int i=0;i<redeemHistoryModel.redeemrequest.length;i++){
        redeemHistoryList.add(redeemHistoryModel);
      }
      }
    } else {
      print("Redeem History :${resp.statusCode}");
    }
  }
}
