import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/utils.dart';
import 'package:libertypaints/controller/Credential/SignInController.dart';
import 'package:libertypaints/controller/Credential/SignUpController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Profile/AllProfilePage.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/profileControllers/MainProfileUpdateController.dart';

class MainProfile extends StatefulWidget {
  final String token;
  const MainProfile({Key? key, required this.token}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  MainProfileUpdateController mainProfileUpdateController =
  Get.put(MainProfileUpdateController());
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  late int _isSeleceted;

  late SharedPreferences pref;
  fetchData() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      name.text = pref.getString("name").toString();
      email.text = pref.getString("email").toString();
      phone.text =  pref.getString("mobile").toString();
    });
  }

  @override
  void initState() {

    //token=signInController.tokens[0].toString();
    print("Access token ${widget.token}");
   if(mounted){
     setState(() {
       mainProfileUpdateController.fetchMainProfileUpdate(widget.token);
     });
   }

    super.initState();
  }

  @override
  void dispose() {
    pref.clear();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    final SaveButton = MaterialButton(
      onPressed: () {
        Get.delete<MainProfileUpdateController>();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => AllProfiles(
                  token: widget.token,
                  username: name.text != null ? name.text : "",
                )));
      },
      child: Text('Show Full Details',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      height: 50,
      minWidth: 250,
      color: Ccolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Profile"),
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
        backgroundColor: Ccolor,
      ),
      body: Obx(() {
        return mainProfileUpdateController.mainProfileModel.isNotEmpty
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.contain,
                      ),

                    ),
                  ),
                ),
                SizedBox(height:5),
                Text("${name.text}",
                    style: TextStyle(color: Ccolor, fontSize: 20)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Membership Card No",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text("${mainProfileUpdateController.mainProfileModel[0].membershipid}")
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Name",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      //border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    keyboardType: TextInputType.phone,
                    controller: phone,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Mobile Number",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      //border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Email",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    )),
                SizedBox(
                  height: 20,
                ),

                // Text(
                //   "Gender",
                //   style: TextStyle(color: Ccolor, fontSize: 20),
                // ),
                // SizedBox(
                //   height: 5,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 75.0),
                //   child: Row(
                //     children: [
                //       addRadioButton(0, "Male"),
                //       addRadioButton(1, "Female"),
                //     ],
                //   ),
                // ),
                SaveButton
              ],
            ),
          ),
        )
            : Center(child: CircularProgressIndicator());
      }),
    );
  }

  List gender = [
    "Male",
    "Female",
  ];
  late String select = "Male";

  Widget addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          activeColor: Ccolor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (dynamic value) {
            setState(() {
              select = value;
              print(value);
            });
          },
        ),
        Text(title)
      ],
    );
  }
}
