import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/CredentialModel/KycEditDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycDetailsController extends GetxController {
  List<KycEditDetailsModel> kycEditDetails = <KycEditDetailsModel>[].obs;
  fetchKycEditDetails(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = await http
        .get(Uri.parse("${baseUrl}api/userKycDetailsEditApi"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final result = kycEditDetailsModelFromJson(res.body);
    if (res.statusCode == 200) {
      if (res.body.isNotEmpty) {
        kycEditDetails.clear();
        kycEditDetails.add(result);
        print("Kyc Details:$kycEditDetails");
        if (kycEditDetails.isNotEmpty) {
          kycEditDetails.first.adharNo != null
              ? preferences.setString(
                  "Aadhaar", "${kycEditDetails.first.adharNo}")
              : "";
          kycEditDetails.first.drivingLicence != null
              ? preferences.setString(
                  "driving", "${kycEditDetails.first.drivingLicence}")
              : "";
          kycEditDetails.first.voterId != null
              ? preferences.setString(
                  "voter", "${kycEditDetails.first.voterId}")
              : "";
          kycEditDetails.first.panNo != null
              ? preferences.setString("pan", "${kycEditDetails.first.panNo}")
              : "";
        }
      }
    }
    print("Kyc Details Data:${res.body}");
  }
}
