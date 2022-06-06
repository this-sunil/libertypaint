import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

class ScanPages extends StatefulWidget {
  const ScanPages({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPages> {
  String qrCodeResult = "Not Yet Scanned";
  List<Product> product = [];
  String data = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Result",
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: const EdgeInsets.all(15.0),
              color: Ccolor,
              onPressed: () async {
                var codeScanner = (await BarcodeScanner.scan(
                    options: const ScanOptions(
                        autoEnableFlash: true,
                        useCamera: -1,
                        android: AndroidOptions(
                          useAutoFocus: true,
                          aspectTolerance: 20.0,
                        )))); //barcode scnner
                setState(() {
                  qrCodeResult = codeScanner.rawContent;
                  //codeSanner.type.name;
                  //refresh(qrCodeResult);
                  Map<String, dynamic> res = jsonDecode(qrCodeResult);
                  print("QRCODE:${res["name"]}");
                  //var a=res["name"];
                  //print("Rwesult a $a");
                  product.add(Product.fromJson(res));
                  print("Product  ${product[0].name}");
                  print("NumberProduct  ${product[0].number}");

                  //product.add(Product(
                  //   number: res['number'],
                  //   name: res["name"],
                  //   products: res["Product"],
                  //   price: res["price"],
                  //   category: res["category"],
                  //   points: res["points"],
                  //   money: res["money"],
                  // ));
                  print("Product Data ${product[0].name}");
                  if (qrCodeResult != "Not Yet Scanned") {}
                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }
              },
              child: const Text(
                "Open Scanner",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ],
        ),
      ),
    );
  }

//its quite simple as that you can use try and catch staatements too for platform exception
}

class Product {
  String? number;
  String? name;
  String? products;
  String? price;
  String? category;
  int? points;
  int? money;
  Product(
      {this.number,
      this.name,
      this.products,
      this.price,
      this.category,
      this.points,
      this.money});

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      number: map["number"],
      name: map["name"],
      products: map["Product"],
      price: map["price"],
      category: map["category"],
      points: map["points"],
      money: map["money"],
    );
  }
}
