import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/CredentialModel/BankDetailsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankDetailsController extends GetxController {
  List<BankDetailsModel> bankDetails = <BankDetailsModel>[].obs;
  fetchBankDetails(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final res = await http.get(
      Uri.parse("${baseUrl}api/userBankDetailsEditApi"),
      headers: {
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final result = bankDetailsModelFromJson(res.body);
    // Map<String,dynamic> map=jsonDecode(res.body);
    if (res.statusCode == 200) {
      if (res.body.isNotEmpty) {
        /*pref.remove("bankCheckbook");
        pref.remove("bankPassbook");*/
        print("Bank Response ${res.body}");
        bankDetails.clear();
        bankDetails.add(result);
        if (bankDetails.isNotEmpty) {
          bankDetails.first.bankIfsc != null
              ? pref.setString("ifsc", "${bankDetails[0].bankIfsc}")
              : "";
          bankDetails.first.bankAccNo != null
              ? pref.setString("bankAccountNo", "${bankDetails[0].bankAccNo}")
              : "";
          bankDetails.first.bankName != null
              ? pref.setString("bankName", "${bankDetails[0].bankName}")
              : "";
          bankDetails.first.bankAccType != null
              ? pref.setString("accountType", "${bankDetails[0].bankAccType}")
              : "";
          bankDetails.first.upiPin != null
              ? pref.setString("upi_pin", "${bankDetails[0].upiPin}")
              : "";
          bankDetails.first.bankAccHolderName != null
              ? pref.setString(
                  "bankHolderName", "${bankDetails[0].bankAccHolderName}")
              : "";
          bankDetails.first.bankCheckbook != null
              ? pref.setString(
                  "bankCheckbook", "${bankDetails[0].bankCheckbook}")
              : "";
          bankDetails.first.bankPassbook != null
              ? pref.setString("bankPassbook", "${bankDetails[0].bankPassbook}")
              : "";
        }
      }
    }
  }
}
