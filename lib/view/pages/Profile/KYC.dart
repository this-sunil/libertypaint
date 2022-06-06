import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/profileControllers/KycEditDetailsController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KYCPage extends StatefulWidget {
  final String token;
  const KYCPage({Key? key, required this.token}) : super(key: key);

  @override
  State<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  TextEditingController adharcardNo = TextEditingController();
  TextEditingController voterCardNo = TextEditingController();
  TextEditingController DrivingLicNo = TextEditingController();
  TextEditingController panCardNo = TextEditingController();
  final GlobalKey<FormState> kycDetailsKey = GlobalKey<FormState>();
  KycDetailsController kycDetailsController = Get.put(KycDetailsController());
  late SharedPreferences preferences;
  fetchData() async {
   preferences = await SharedPreferences.getInstance();
    setState(() {
      adharcardNo.text = preferences.getString("Aadhaar").toString();
      voterCardNo.text = preferences.getString("driving").toString();
      DrivingLicNo.text = preferences.getString("voter").toString();
      panCardNo.text = preferences.getString("pan").toString();
    });
  }

  @override
  void initState() {
   if(mounted){
     setState(() {
       kycDetailsController.fetchKycEditDetails(widget.token);

     });
   }

    super.initState();
  }

  @override
  void dispose() {
    kycDetailsController.kycEditDetails.clear();
    preferences.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: Text("Kyc Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Badge(
              showBadge: counter.counter==0?false:true,
              badgeContent:  Text("${counter.counter}"),
              badgeColor: Colors.white,
              position: BadgePosition.topEnd(end: 0,top: 0),
              child: IconButton(onPressed: (){
                print("Token Data:${widget.token}");

                Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetails(token: widget.token)));
                setState(() {
                  counter.decrement();
                });

              }, icon: const Icon(Icons.notifications_outlined,color: Colors.white,size: 28)),
            ),
          ),
        ],
      ),
      body:Obx((){
        if(kycDetailsController.kycEditDetails.isNotEmpty){
          return  SingleChildScrollView(
            child: Form(
              key: kycDetailsKey,
              child: Column(
                children: [
                  /*AdharCard Details*/
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("images/adharlogo.jpg"),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Aadhaar Card",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Flexible(
                                flex: 2,
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                      child: Text(
                                          "Your details verified by using your Aadhaar Number,our team will contact you soon."),
                                    ))),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Aadhaar Number"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 30),
                          child: TextFormField(
                            maxLength: 12,
                            controller: adharcardNo,
                            decoration: InputDecoration(counterText: ""),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your aadhaar card number";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Driving Details*/
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                AssetImage("images/driverlicence.jpg"),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Driving Licence",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Flexible(
                                flex: 2,
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 4.0, right: 4.0, bottom: 30),
                                      child: Text(
                                          "Your details verified by using your Driving Licence,our team will contact you soon."),
                                    ))),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Licence Number"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 30),
                          child: TextFormField(
                            maxLength: 20,
                            controller: DrivingLicNo,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your driving license number";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Voter Card Details*/
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("images/voterlogo.png"),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Voter Card",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Flexible(
                                flex: 2,
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                      child: Text(
                                          "Your details verified by using your Voter Card,our team will contact you soon."),
                                    ))),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Voter Card Number"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 30),
                          child: TextFormField(
                            maxLength: 20,
                            controller: voterCardNo,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your voter card number";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Pan Card Details*/
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("images/pan-card.jpg"),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Pan Card",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Flexible(
                                flex: 2,
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                      child: Text(
                                          "Your details verified by using your Pan Card,our team will contact you soon."),
                                    ))),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Pan Card Number"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 20),
                          child: TextFormField(
                            maxLength: 20,
                            controller: panCardNo,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your pan card number";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(Ccolor)),
                                onPressed: () async {
                                  final resp = await http.post(
                                    Uri.parse(
                                        "${baseUrl}api/userKycDetailsUpdateApi"),
                                    body: {
                                      "adhar_no": adharcardNo.text,
                                      "pan_no": panCardNo.text,
                                      "voter_id": voterCardNo.text,
                                      "driving_licence": DrivingLicNo.text,
                                    },
                                    headers: {
                                      'Accept': 'application/json',
                                      'Authorization': 'Bearer ${widget.token}',
                                    },
                                  );
                                  Map<String, dynamic> result =
                                  jsonDecode(resp.body);
                                  if (resp.statusCode == 200) {
                                    Fluttertoast.showToast(msg: result["message"]);
                                  } else {
                                    Fluttertoast.showToast(msg: result["message"]);
                                  }
                                },
                                child: Text("Submit")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
