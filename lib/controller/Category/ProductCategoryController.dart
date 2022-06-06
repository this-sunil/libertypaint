import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/CategoryModel/CategoryProductModel.dart';
class ProductCategoryController extends GetxController{
  List<ProductCategoryModel> productList=<ProductCategoryModel>[].obs;
  fetchProductCategory(String token) async{
    final res=await http.get(Uri.parse("${baseUrl}api/getCategoriesApi"),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );
    final productCategoryModel=productCategoryModelFromJson(res.body);
    if(res.statusCode==200){
      if(productCategoryModel.isNotEmpty){
        productList.clear();
        productList.addAll(productCategoryModel);
      }
    }
    else{
      print("Product Category ${res.statusCode}");
    }
  }
}