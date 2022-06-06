import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/SliderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliderController extends GetxController {
  List<SliderModel> sliderImage = <SliderModel>[].obs;
  fetchSliderData(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      final resp =
      await http.get(Uri.parse("${baseUrl}api/getSlidersApi"), headers: {
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      });
      final sliderModel = sliderModelFromJson(resp.body);
      if (resp.statusCode == 200) {
        print("Slider Data" + resp.body);
        if (resp.body.isNotEmpty) {
          sliderImage.clear();
          sliderImage.addAll(sliderModel);
        }
      }
    }catch(e) {
      print("Server Error Slider Controller ${e.toString()}");
    }
  }
}
