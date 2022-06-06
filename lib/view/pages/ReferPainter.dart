import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/History/ReferPainterHistoryController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class ReferPainter extends StatefulWidget {
  final String token;
  const ReferPainter({Key? key,required this.token}) : super(key: key);

  @override
  State<ReferPainter> createState() => _ReferPainterState();
}

class _ReferPainterState extends State<ReferPainter>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  //late PhoneContact contact;
  ReferPainterHistoryController referPainterHistoryController=Get.put(ReferPainterHistoryController());
  TextEditingController referCode=TextEditingController();
  TextEditingController painterName=TextEditingController();
  TextEditingController painterMobileNo=TextEditingController();
  TextEditingController paineterEmail=TextEditingController();
  /*void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }*/
  Future<void> referPainter() async {

    await FlutterShare.share(
        title: 'Liberty Paint',
        text: 'your referral code is ${referCode.text} \n Click to join:-',
        linkUrl: 'https://play.google.com/store/apps',
    );
  }
  getNumber(String contact){
    setState(() {
      painterMobileNo.text=contact;
    });
  }
  //List<String> referralCode=[];
  fetchData(String token) async{
    final resp=await http.get(Uri.parse("${baseUrl}api/generateReferralCode"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    Map<String,dynamic> result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      if(resp.body.isNotEmpty){
       // referralCode.clear();
        referCode.text=result["code"];
       // referralCode.add(result["code"]);
        print("Result:${result["code"]}");
      }
    }
   /*if(mounted){
     setState(() {
       if(referralCode.isNotEmpty){
         setState(() {
           referCode.text=referralCode.first;
           print("Main Refer Code ${referCode.text}");
         });
       }
     });
   }*/

  }
  @override
  void initState() {

    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // TODO: implement initState

    setState(() {
      referCode.clear();
      referPainterHistoryController.fetchReferHistory(widget.token);
      fetchData(widget.token);
    });
    super.initState();
  }
@override
  void dispose() {
    referCode.clear();
    referPainterHistoryController.referPainterHistory.clear();
   // referralCode.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: Text(
          "Refer Painter",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color:Ccolor,
                ),
                controller: tabController,
                tabs: [
                  Tab(
                    // icon: Icon(Icons.add),
                    child: Text("Refer a Painter"),
                  ),
                  Tab(
                    //icon: Icon(Icons.clear),
                    child: Text("History"),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ////////Tab Bar One//////////
               SingleChildScrollView(
                 child:  Column(
                   children: [
                     Text("Enter Details",style: TextStyle(fontSize: 20,color: Ccolor,fontWeight: FontWeight.bold),),

                    /* Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextField(
                           controller: painterName,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                             focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Ccolor),
                             ),
                             hintText: "Painter Name",
                             contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextField(
                         controller: painterName,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                             focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Ccolor),
                             ),
                             hintText: "Painter Name",
                             contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextFormField(
                           keyboardType: TextInputType.text,
                           controller: painterMobileNo,
                           onChanged: (value){
                             setState(() {

                             });
                           },
                           decoration: InputDecoration(

                             suffixIcon: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: IconButton(icon: const FaIcon(FontAwesomeIcons.addressBook),onPressed: () async{
                                 contact =
                                     await FlutterContactPicker.pickPhoneContact();
                                 getNumber(contact.phoneNumber!.number.toString());


                               }),
                             ),
                             focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Ccolor),
                             ),
                             hintText: "Painters Mobile Number",

                             contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextField(
                         controller: paineterEmail,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                             focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Ccolor),
                             ),
                             hintText: "Email(Optional)",
                             contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

                           )),
                     ),*/
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextFormField(

                          controller: referCode,
                           keyboardType: TextInputType.text,

                           decoration: InputDecoration(
                             focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Ccolor),
                             ),
                             suffixIcon: IconButton(icon: const Icon(Icons.copy,color: Colors.black),onPressed: (){
                               Clipboard.setData(ClipboardData(text: referCode.text)).then((_){
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Referral Code copied to clipboard")));
                               });
                             }),
                             hintText: "Referral code",
                             contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

                           )),
                     ),
                     const SizedBox(height: 20),
                     MaterialButton(

                       onPressed: () {
                        // _sendSMS("Dear ${painterName.text}, Membership No has referred you to join Liberty Paint a program for painting Contractors,Use referral code DH4WS2 during registration & enjoy exciting rewards with Liberty \n Click to join:-https://play.google.com/store/apps", [painterMobileNo.text]);
                         referPainter();
                       },
                       child: const Text('Send', style: TextStyle(color: Colors.white, fontSize: 20)),
                       height: 50,
                       minWidth: 250,
                       color: Ccolor,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                     )


                   ],
                 ),
               ),

                ////////Tab Bar 2 Begin/////////////////////
                Obx((){
                  if(referPainterHistoryController.referPainterHistory.isEmpty){
                    return Center(child: Image.asset("images/no-data.png"));
                  }
                  return referPainterHistoryController.referPainterHistory.isNotEmpty?ListView.builder(
                      itemCount: referPainterHistoryController.referPainterHistory.length,
                      itemBuilder: (context, index) {
                        return  Card(
                          child: ListTile(

                            title: Text("Refer code:"+referPainterHistoryController.referPainterHistory[index].code),
                            subtitle: Text(formatDate(DateTime.parse(referPainterHistoryController.referPainterHistory[index].date),[MM])+","+formatDate(DateTime.parse(referPainterHistoryController.referPainterHistory[index].date),[yyyy]) +" at "+referPainterHistoryController.referPainterHistory[index].time+" "+formatDate(DateTime.parse(referPainterHistoryController.referPainterHistory[index].date),[am])),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("${referPainterHistoryController.referPainterHistory[index].points} pts"),
                                Text(referPainterHistoryController.referPainterHistory[index].money+" \u{20B9}"),
                              ],
                            ),
                          ),
                        );
                      }):const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
