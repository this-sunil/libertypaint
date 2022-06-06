import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'dart:convert';

import 'package:libertypaints/model/VideoModels.dart';
class TrainingVideoController extends GetxController{
  List<VideosModel> videomodels=<VideosModel>[].obs;
  fetchVideosData(String token) async{
    final res= await http.get(Uri.parse("${baseUrl}api/getTrainingVideosApi"),headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final videoModel=videosModelFromJson(res.body);
    if(res.statusCode==200){
      if(videoModel.isNotEmpty){
        videomodels.clear();
        videomodels.addAll(videoModel);
      }
    }
    else{
      print(res.statusCode);
    }
  }
}