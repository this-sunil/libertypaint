import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/ProfileModels/PersonalDetailModel.dart';

class PersonalDetailController extends GetxController {
  List<PersnalDetailUpdate> persnalModel = <PersnalDetailUpdate>[].obs;
  fetchPersonalDetail(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final res = await http
        .get(Uri.parse("${baseUrl}api/userPersonalDetailsEditApi"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    PersnalDetailUpdate list = persnalDetailUpdateFromJson(res.body);
    print("Personal Controller ${res.body}");

    if (res.statusCode == 200) {
      if (res.body.isNotEmpty) {
        persnalModel.clear();

        persnalModel.add(list);
        if(persnalModel.isNotEmpty){
          persnalModel.isNotEmpty?pref.setString("pname", "${persnalModel[0].name}"):"";
          persnalModel.isNotEmpty?pref.setString("pemail", "${persnalModel[0].email}"):"";
          persnalModel.isNotEmpty?pref.setString("pmobile", "${persnalModel[0].mobile}"):"";
        }
      }
    }
    return persnalDetailUpdateFromJson(res.body);
  }
}
