import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/Connectivity/ConnectionManagerController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Drawer.dart';
import 'package:libertypaints/view/pages/HomePage.dart';
import 'package:libertypaints/view/pages/RewardPage.dart';
import 'package:libertypaints/view/pages/ScanPage.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final String token;
  const MainScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
//ConnectionManagerController connectionManagerController=Get.put(ConnectionManagerController());
  List<Widget> pages = [];
  late Widget currentIndex;
  int currentPage = 0;
  DateTime? backButtonPressTime;
  final snackBar = const SnackBar(
    content: Text('Press back again to leave'),
    duration: Duration(seconds: 3),
  );
  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }

  var data;
  storeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("key", widget.token);

    data = sharedPreferences.getString("key");
    print("Token data into sharedPreferences:$data");
  }
  fetchData(BuildContext context) async{
    final counter=Provider.of<NotificationCounters>(context,listen: false);


    FirebaseMessaging.onMessage.listen((event) {
      print("notification count");
      counter.increment();
      //incrementNotifier();
      //notificationCounter.incrementNotifier(notificationCounterValueNotifer);

    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //notificationCounterValueNotifer.value=0;
      setState(() {
        counter.decrement();
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetails(token: widget.token)));
    });

  }
  @override
  void initState() {

    storeData();

    //connectionManagerController.getConnectivityType();
    HomePage homePage =
        HomePage(token: widget.token == null ? data : widget.token);
    RewardPage rewardPage =
        RewardPage(token: widget.token == null ? data : widget.token);
    ScanPage scanPage =
        ScanPage(token: widget.token == null ? data : widget.token);
    pages = [homePage, scanPage, rewardPage];
    currentIndex = pages[0];

    super.initState();
  }

  @override
  void dispose() {
    widget.token != "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fetchData(context);
    return WillPopScope(
      onWillPop: () => handleWillPop(context),
      child: Scaffold(
        appBar: currentPage == 1 || currentPage == 2
            ? null
            : AppBar(
                leading: Builder(builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.black),
                  );
                }),
                bottomOpacity: 0,
                elevation: 0,
                title: const Text(
                  "Liberty Paints",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                //actions: [IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))],
              ),
        drawer: Drawer(
          // backgroundColor: Colors.black,
          child: DrawerWidget(token: widget.token),
        ),
        body: currentIndex,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          fixedColor: Ccolor,
          onTap: (index) {
            setState(() {
              currentPage = index;
              currentIndex = pages[currentPage];
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner_rounded), label: "Scan"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.gift), label: "Reward"),
          ],
        ),
      ),
    );
  }
}
