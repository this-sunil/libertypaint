import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/HistoryModel/ScanHistoryModel.dart';
class ScanHistoryController extends GetxController{
  List<ScanModelHistory> scanHistory=<ScanModelHistory>[].obs;
  bool scanHistorys=false;
  fetchScanHistoryData(String token) async{
   scanHistorys=true;
    final res=await http.get(Uri.parse("${baseUrl}api/qrScannedHistory"),
    headers: {
      "accept":"application/json",
      'Authorization': 'Bearer $token',
    },
    );
    final scanHistoryModel=scanModelHistoryFromJson(res.body);
    //Map<String,dynamic> result=jsonDecode(res.body);
    if(res.statusCode==200){
      scanHistory.clear();
      print("Successful History");
      scanHistory.addAll(scanHistoryModel);
    }
    else{
      print("Cancel");
    }

  }
}