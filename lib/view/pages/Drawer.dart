import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/profileControllers/MainProfileUpdateController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/AboutUsPage.dart';
import 'package:libertypaints/view/pages/Complaint.dart';
import 'package:libertypaints/view/pages/ContactUs.dart';
import 'package:libertypaints/view/pages/HelpCenterPage.dart';
import 'package:libertypaints/view/pages/LoginPage.dart';
import 'package:libertypaints/view/pages/Privacy&PolicyPage.dart';
import 'package:libertypaints/view/pages/Profile/MainProfile.dart';
import 'package:libertypaints/view/pages/Screen/SignInPage.dart';
import 'package:libertypaints/view/pages/Utility/flutter-icons/my_flutter_app_icons.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  final String token;
   const DrawerWidget({Key? key,required this.token}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: FittedBox(
            child: Image.asset("assets/logo.png"),
            fit: BoxFit.cover,
          )
          // child: C
        ),
        // Container(
        //   child: DrawerHeader(child: Image.asset("assets/logo.png")),
        // ),
        SizedBox(height: 20,),
        ListTile(
          title: const Text('My Profile',style: TextStyle(fontSize: 14,),),
          leading: FaIcon(FontAwesomeIcons.user,color: Ccolor,size: 20,),

          onTap: () {
            Get.delete<MainProfileUpdateController>();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainProfile(token: widget.token)));
          },
        ),
        ListTile(
          title:  Text('Notification',style: TextStyle(fontSize: 14),),
          leading:FaIcon(FontAwesomeIcons.bell,color: Ccolor,size: 20,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetails(token: widget.token)));
            setState(() {
              counter.decrement();
            });
          },

        ),
        ListTile(
          title: const Text('About The App',style: TextStyle(fontSize: 14),),
          leading:FaIcon(FontAwesomeIcons.infoCircle,color: Ccolor,size: 18,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsPage(token: widget.token)));
          },

        ),

        ListTile(
          title: const Text('Complaints',style: TextStyle(fontSize: 14),),
          leading:Icon(MyFlutterApp.complaint,color: Ccolor,size: 20),
          // trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ComplaintPage(token: widget.token)));
          },
        ),

        ListTile(
          title: const Text('Help Center',style: TextStyle(fontSize: 14),),
          leading:FaIcon(FontAwesomeIcons.question,color: Ccolor,size: 20,),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>HelpCenterPage(token: widget.token)));
          },
        ),
        ListTile(
          title: const Text('Contact Us',style: TextStyle(fontSize: 14),),
          leading:FaIcon(FontAwesomeIcons.phone,color: Ccolor,size: 18,),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>ContactUs(token: widget.token)));
          },
        ),
        ListTile(
          title: const Text('Privacy And Policy',style: TextStyle(fontSize: 14),),
          leading: FaIcon(FontAwesomeIcons.shield,color: Ccolor,size: 20,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyPage(token: widget.token)));
          },
        ),
        const Divider(),
        ListTile(
            title: const Text('Sign Out',style: TextStyle(fontSize: 14),),
            leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket,color: Ccolor,size: 20,),
          onTap: () async{
              SharedPreferences pref=await SharedPreferences.getInstance();
              pref.clear();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignInPage()));
          },
        ),
      ],
    );
    //   Obx((){
    //   // if(sampleController.login.obs.value){
    //   //   print(sampleController.login.obs.value);
    //   //   return CircularProgressIndicator();
    //   // }
    //   return
    // });

  }
}
