// To parse this JSON data, do
//
//     final productCategoryModel = productCategoryModelFromJson(jsonString);

import 'dart:convert';

List<ProductCategoryModel> productCategoryModelFromJson(String str) => List<ProductCategoryModel>.from(json.decode(str).map((x) => ProductCategoryModel.fromJson(x)));

String productCategoryModelToJson(List<ProductCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductCategoryModel {
  ProductCategoryModel({
    required this.key,
    required this.name,
    required this.image,
  });

  String key;
  String name;
  String image;

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    key: json["key"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "image": image,
  };
}
