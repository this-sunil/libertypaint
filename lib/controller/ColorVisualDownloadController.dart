import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libertypaints/config.dart';
import 'package:get/get.dart';
import 'package:libertypaints/model/DownloadFileModel.dart';
class ColorVisualDownloadController extends GetxController{
  List<DownloadFileModel> downloadFile=<DownloadFileModel>[].obs;
  fetchDownloadFile(String token) async{

    final resp=await http.get(Uri.parse("${baseUrl}api/visualizationFileDownloadApi"),
    headers: {
      "accept":"application/json",
      'Authorization': 'Bearer $token',
    },
    );
    final maps=downloadFileModelFromJson(resp.body);
    print("Response $maps['file']");
    if(resp.statusCode==200){
      downloadFile.clear();
       downloadFile.add(maps);
      // Fluttertoast.showToast(msg: "${downloadFile[0].file}");
    }
    else{
      Fluttertoast.showToast(msg: "${resp.body}");
    }
  }
}
