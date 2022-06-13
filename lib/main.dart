import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libertypaints/view/main_Screen.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/notification/Notifications.dart';
import 'package:libertypaints/view/pages/Utility/SplashScreen.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

late String data;
bool flag = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  data = preferences.getString("key").toString();



  print("Coming started data with main $data");

  await Firebase.initializeApp().then((value) {
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.instance.getToken();
    print(
        "Firebase Started in Liberty Paint App ${value.isAutomaticDataCollectionEnabled}");
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    CustomNotification().init();
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Remote Message:${message.data}");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // This widget is the root of your application.
  late SharedPreferences pref;
  int count = 0;

  @override
  void initState() {
    print("Firebase Message");
    setState(() {
      setState(() {
        if(data=="null"){
          flag=false;
          print("Token of sharedPreferences $flag");

        }
        else{
          flag=true;
          print("Coming started data with main $data");
        }

      });
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        setState(() {
          backgroundMessageHandler(message);
        });
      }
    });

    //CustomNotification().createNotification("Hi Bro","welcome Liberty Paint");
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("${event.notification!.title}");
      print("${event.notification!.body}");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NotificationDetails(token: data.toString())));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message token");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        CustomNotification().createNotification(
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            message.notification!.android!.imageUrl.toString());

        //print(message.notification!.android!.count);
        firebaseMessaging.getToken().then((token) {
          print("Device Token: $token");
          FirebaseFirestore.instance.collection("/$token").doc().set({
            "title": message.notification!.title,
            "message": message.notification!.body,
            "image": message.notification!.android!.imageUrl,
          });
        });

        /*  AwesomeNotifications().actionStream.listen((notification) {
          if (notification.channelKey == 'basic_channel' && Platform.isIOS) {

            AwesomeNotifications().getGlobalBadgeCounter().then(
                  (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),

            );
          }


        });*/
        FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        /*  notificationCounterValueNotifer.value=notificationCounterValueNotifer.value+1;
        notificationCounterValueNotifer.notifyListeners();
       print("count ${notificationCounterValueNotifer.value}");
        pref.setString("count", notificationCounterValueNotifer.value.toString());*/
      }
    });

    CustomNotification().display();
    // listeners here so ValueListenableBuilder will build the widget.
    super.initState();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    pref.remove("count");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationCounters>(
      create: (_) => NotificationCounters(0),
      child: GetMaterialApp(
        title: 'Liberty Paint',
        //initialBinding: ControllerBinding(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Ccolor,
          primarySwatch: Colors.brown,
          fontFamily: 'Bitter',
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'Bitter'),
          ),
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Ccolor,
          ),
        ),
        home: flag == false ? const SplashScreen() : MainScreen(token: "$data"),

        /*   home: flag==false?SplashScreenView(
          textStyle: TextStyle(fontSize: 25,color: Ccolor),
          imageSize: 300,
          duration: 5000,
          text: "Welcome to Liberty Paint",
          textType: TextType.TyperAnimatedText,
          pageRouteTransition: PageRouteTransition.SlideTransition,
          imageSrc: "images/splashLogo.png", navigateRoute: LoginPage(),

        ):MainScreen(token: "$data"),*/
      ),
    );
  }
}
