import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/userPoints.dart';
class ScanController extends GetxController{

  List<UserPontModel> userPointsList=<UserPontModel>[].obs;
  fetchScanData(String token) async{

    final res=await http.get(Uri.parse("${baseUrl}api/userPointsBalance"),
      headers: {
        "accept":"application/json",
        'Authorization': 'Bearer $token',
      },
    );
   final result=userPontModelFromJson(res.body);
    if(res.statusCode==200){
      if(res.body.isNotEmpty){
        userPointsList.clear();
        print("Response:${res.body}");
        userPointsList.add(result);
      }
    }
    print("OR Code Details Data:${res.body}");
  }
}