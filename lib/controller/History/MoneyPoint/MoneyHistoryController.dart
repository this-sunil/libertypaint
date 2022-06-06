import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/model/HistoryModel/MoneyHistoryModel.dart';

class MoneyHistoryController extends GetxController {
  List<MoneyHistoryModel> moneyHistoryPoint = <MoneyHistoryModel>[].obs;
  fetchRedeemMoneyHistory(String token) async {
    final resp = await http.get(
      Uri.parse("${baseUrl}api/scannedMoneyHistory"),
      headers: {
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final moneyHistoryModel = moneyHistoryModelFromJson(resp.body);
    if (resp.statusCode == 200) {
      moneyHistoryPoint.clear();
      moneyHistoryPoint.addAll(moneyHistoryModel);
      print("Money History ${resp.body}");
    } else {
      print("Money History error${resp.statusCode}");
    }
  }
}
