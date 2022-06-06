import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ProfileModels/MainProfileUpadeModel.dart';

class MainProfileUpdateController extends GetxController {
  @override
  OnInit() {
    //fetchMainProfileUpdate();
    super.onInit();
  }

  List<MainProfileUpdateModel> mainProfileModel =
      <MainProfileUpdateModel>[].obs;
  fetchMainProfileUpdate(String token) async {
    print("Token:$token");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final res =
        await http.get(Uri.parse("${baseUrl}api/userProfileEditApi"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      //8|xs2XwLDGpcgF810Fsj45luE1synyfrNPPSgKmv93
    });

    MainProfileUpdateModel mainProfileUpdateModel =
        mainProfileUpdateModelFromJson(res.body);

    if (res.statusCode == 200) {
      if (res.body.isNotEmpty) {
        mainProfileModel.clear();
        print("MainProfileUpdate Controller Body ${res.body}");
        mainProfileModel.add(mainProfileUpdateModel);
        mainProfileModel.first.name.isNotEmpty
            ? sharedPreferences.setString("name", "${mainProfileModel[0].name}")
            : "";
        mainProfileModel.first.mobile.isNotEmpty
            ? sharedPreferences.setString(
                "mobile", "${mainProfileModel[0].mobile}")
            : "";
        mainProfileModel.first.email.isNotEmpty
            ? sharedPreferences.setString(
                "email", "${mainProfileModel[0].email}")
            : "";
        //membershipid: mainProfileUpdateModel.membershipid!=null?mainProfileUpdateModel.membershipid:"-"));
      }
    } else {
      Fluttertoast.showToast(msg: "Error");
    }
    return mainProfileUpdateModelFromJson(res.body);
  }
}
