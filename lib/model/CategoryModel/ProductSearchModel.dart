// To parse this JSON data, do
//
//     final productSearchModel = productSearchModelFromJson(jsonString);

import 'dart:convert';

List<ProductSearchModel> productSearchModelFromJson(String str) => List<ProductSearchModel>.from(json.decode(str).map((x) => ProductSearchModel.fromJson(x)));

String productSearchModelToJson(List<ProductSearchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductSearchModel {
  ProductSearchModel({
    required this.name,
    required this.price,
    required this.image,
  });

  String name;
  String price;
  String image;

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) => ProductSearchModel(
    name: json["name"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "image": image,
  };
}
