import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/Credential/SignInController.dart';
import 'package:libertypaints/controller/Credential/SignUpController.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/profileControllers/PresonalDetailController.dart';

class PersonalDetail extends StatefulWidget {
  final String token;
  const PersonalDetail({Key? key, required this.token}) : super(key: key);

  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  PersonalDetailController personalDetailController =
      Get.put(PersonalDetailController());
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController status = TextEditingController();
  SignInController signInController = Get.put(SignInController());
  SignUpController signUpController = Get.put(SignUpController());
late  SharedPreferences pref;
  fetchData() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      name.text = pref.getString("pname").toString();
      email.text =pref.getString("pemail").toString();
      mobile.text =pref.getString("pmobile").toString();
    });
  }

  @override
  void initState() {
   if(mounted){
     setState(() {
       personalDetailController.fetchPersonalDetail(widget.token);

     });
   }

    /*  Future.delayed(Duration(seconds: 3),(){
      setState(() {
        name.text=personalDetailController.persnalModel.first.name.toString();
        email.text=personalDetailController.persnalModel.first.email.toString();
        mobile.text=personalDetailController.persnalModel.first.mobile.toString();
      });


    });*/
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    personalDetailController.persnalModel.clear();
    // TODO: implement dispose
    name.clear();
    email.clear();
    mobile.clear();
    pref.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Ccolor,
          title: const Text(
            "Personal Detail",
            style: TextStyle(color: Colors.white),
          ),
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
          if(personalDetailController.persnalModel.isNotEmpty){
           return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: name,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Full Name",
                            ),
                            // controller: _phoneController
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: mobile,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Mobile Number",
                            ),
                            // controller: _phoneController
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Email ID(Optional)",
                            ),
                            // controller: _phoneController
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),


                        MaterialButton(
                          onPressed: ()  async{
                            final resp=await http.post(Uri.parse("${baseUrl}api/userPersonalDetailsUpdateApi"),
                                headers: {
                                  'Accept': 'application/json',
                                  'Authorization': 'Bearer ${widget.token}',
                                },
                                body: {
                                  "name":name.text,
                                  "email":email.text,
                                }

                            );
                            Map<String,dynamic> result=jsonDecode(resp.body);
                            if(resp.statusCode==200){
                              Fluttertoast.showToast(msg: result["message"]);
                            }
                            else{
                              Fluttertoast.showToast(msg: result["message"]);
                            }
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));

                          },
                          child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20)),
                          height: 50,
                          minWidth: 250,
                          color: Ccolor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        })


        );
  }
}
