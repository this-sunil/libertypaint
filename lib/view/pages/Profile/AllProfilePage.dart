import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libertypaints/controller/profileControllers/MainProfileUpdateController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
//import 'package:libertypaints/view/pages/Profile/BankDetail.dart';
import 'package:libertypaints/view/pages/Profile/BankDetailsPage.dart';
import 'package:libertypaints/view/pages/Profile/KYC.dart';
import 'package:libertypaints/view/pages/Profile/PersnalDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';

class AllProfiles extends StatefulWidget {
  final String token;
  final String username;
  const AllProfiles({Key? key, required this.token, required this.username})
      : super(key: key);

  @override
  State<AllProfiles> createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfiles> {
  //MainProfileUpdateController mainProfileUpdateController=Get.put(MainProfileUpdateController());

  String? username;

  @override
  void initState() {
    username = widget.username;
    // mainProfileUpdateController.fetchMainProfileUpdate(widget.token);

    /* Future.delayed(Duration(
      seconds: 3,
    ),(){
      setState(() {
        username=mainProfileUpdateController.mainProfileModel[0].name;
      });
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       /* shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),*/
        backgroundColor: Ccolor,
        title: const Text(
          "Profile Details",
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
        /*bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ListTile(title: Text("Profile"),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(Icons.person,color: Colors.white,size: 50,),

                    Text("$username",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),*/
      ),
      body: Column(
        children: [

          Card(
            elevation: 5,
            child: ListTile(
              title: const Text("Personal Details"),
              leading: FaIcon(FontAwesomeIcons.user),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalDetail(
                              token: widget.token,
                            )));
              },
            ),
          ),
          Card(
            elevation: 5,
            child: ListTile(
              title: Text("KYC"),
              leading: FaIcon(FontAwesomeIcons.fileCircleExclamation),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KYCPage(token: widget.token)));
              },
            ),
          ),
          Card(
            elevation: 5,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) =>
                            BankDetailsPage(token: widget.token)));
              },
              title: Text("Bank Details"),
              leading: FaIcon(FontAwesomeIcons.buildingColumns),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
