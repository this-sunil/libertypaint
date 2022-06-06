import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/CategoryModel/ProductSearchModel.dart';
class ProductSearchController extends GetxController{
  List<ProductSearchModel> productSearchList=<ProductSearchModel>[].obs;
  fetchProductSearchCategory(String token,String key) async{
    print("Key $key");
    final res=await http.get(Uri.parse("${baseUrl}api/getProductsApi/$key"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final productCategoryModel=productSearchModelFromJson(res.body);
    if(res.statusCode==200){
      if(productCategoryModel.isNotEmpty){
        productSearchList.clear();
        productSearchList.addAll(productCategoryModel);
        print("Product Search :${res.body}");
      }
    }
    else{
      print("Product Search Category ${res.statusCode}");
    }
  }
}