import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:libertypaints/view/widget/constant.widget.dart';

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

  @override
  void initState() {
    personalDetailController.fetchPersonalDetail(widget.token);
    Future.delayed(Duration(seconds: 3), () {
      name.text = personalDetailController.persnalModel.first.name.toString();
      email.text = personalDetailController.persnalModel.first.email.toString();
      mobile.text =
          personalDetailController.persnalModel.first.mobile.toString();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    personalDetailController.persnalModel.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Ccolor,
          title: Text(
            "Personal Detail",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              )),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
            ),
          ),
        ),
        body: Obx(() {
          return personalDetailController.persnalModel.isNotEmpty
              ? SingleChildScrollView(
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
                                keyboardType: TextInputType.phone,
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
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: email,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: "Email ID(Optional)",
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
                                controller: status,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: "Material Status",
                                ),
                                // controller: _phoneController
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
                              },
                              child: Text('Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              height: 50,
                              minWidth: 250,
                              color: Ccolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator());
        }));
  }
}
