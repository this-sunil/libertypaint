import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/view/main_Screen.dart';
import 'package:libertypaints/view/pages/RewardPage.dart';
import 'package:libertypaints/view/pages/Utility/scan.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

class ScanPage extends StatefulWidget {
  final String token;
  const ScanPage({Key? key, required this.token}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  List<Product> product = [];
  String data = "";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  ScanQrCode() async {
    var codeScanner = (await BarcodeScanner.scan(
        options: const ScanOptions(
            autoEnableFlash: false,
            useCamera: -1,
            android: AndroidOptions(
              useAutoFocus: true,
              aspectTolerance: 20.0,
            ),
            strings: {
          "cancel": "Cancel",
        }))); //barcode scnner
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
      postQrCode(product[0].number.toString(), widget.token);
    });
    return codeScanner;
  }

  postQrCode(String number, String token) async {
    product.clear();
    print("QR Code Number $number");
    if (qrCodeResult != "Not Yet Scanned") {
      await http.post(Uri.parse("${baseUrl}api/userScannedQrCodes"), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        "number": number,
      }).then((value) {
        Map<String, dynamic> result = jsonDecode(value.body);
        if (value.statusCode == 200) {
          if (result["message"] == "success") {
            Fluttertoast.showToast(msg: "Qr Code Scanned Successfully.");
            //Fluttertoast.showToast(msg: result["message"]);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RewardPage(token: widget.token)));
          } else {
            Fluttertoast.showToast(msg: result["message"]);
          }
        } else {
          Fluttertoast.showToast(msg: "Server error${value.statusCode}");
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    product.clear();
    super.dispose();
  }

  Future<bool> backBtn() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainScreen(token: widget.token)));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backBtn,
      child: Scaffold(
        /* appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text("Scan Qr Code",style: TextStyle(color: Colors.black),

          ),
          centerTitle: true,
        ),*/
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Image(image: AssetImage("assets/ScanImage.jpg")),
            const SizedBox(
              height: 10.0,
            ),
            FlatButton(
              padding: const EdgeInsets.all(15.0),
              color: Ccolor,
              onPressed: () async {
                var codeScanner = (await BarcodeScanner.scan(
                    options: const ScanOptions(
                        autoEnableFlash: false,
                        useCamera: -1,
                        android: AndroidOptions(
                          useAutoFocus: true,
                          aspectTolerance: 20.0,
                        ),
                        strings: {
                      "cancel": "Cancel",
                    }))); //barcode scnner
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
                  postQrCode(product[0].number.toString(), widget.token);
                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }
              },
              child: const Text(
                "Scan QR Code",
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

  /*Widget flatButton(String text, Widget widget) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      color: Ccolor,
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white,width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }*/
}
