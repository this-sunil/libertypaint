import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/controller/Credential/SignUpController.dart';
import 'package:libertypaints/view/main_Screen.dart';
import 'CurvePainter.dart';
import 'package:libertypaints/view/pages/Screen/BottomWaveClipper.dart';
import 'package:libertypaints/view/pages/Screen/CurvePainter.dart';
import 'package:libertypaints/view/pages/Screen/SignInPage.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:libertypaints/config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late ScrollController controller;
  String verificationCode = "";
  TextEditingController Otp = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();
  late String otp = "";
  String deviceToken="";
  bool showPassword = false;

  refresh() async {
    otp = "";
    /* name.clear();
    mobile.clear();
    email.clear();*/
  }

  fetchSignUpData(String name, String mobile, String email, String password,
      String referal) async {
    // SharedPreferences pref=await SharedPreferences.getInstance();
    final resp = await http.post(
      Uri.parse("${baseUrl}api/userReisterApi"),
      headers: {
        "accept": "application/json",
      },
      body: {
        "name": name,
        "mobile": mobile,
        "email": email,
        "password": password,
        "referral_code": referal,
        "device_token":deviceToken,
      },
    );
    Map<String, dynamic> maps = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      //signUpToken.clear();
      Fluttertoast.showToast(msg: maps["message"]);
      // pref.setString("token123", maps["token"]);
      if (maps["token"] != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(token: maps["token"])));
      }
      // signUpToken.add(maps["token"]);
      //print("Token Data ${signUpToken[0]}");
      //print("Print signUp Token:${signUpToken[0].toString()}");
    } else {
      Fluttertoast.showToast(msg: "${maps["message"]}");
    }
  }

  verifyOtp(String otpNo) {

    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: otpKey,
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                "Enter Your Otp",
                style: TextStyle(color: Ccolor),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinFieldAutoFill(
                    codeLength: 6,
                    currentCode: otpNo,

                    keyboardType: TextInputType.phone,
                    onCodeChanged: (code) {
                     if(mounted){
                       setState(() {
                         otpNo = code.toString();
                       });
                     }
                    },
                    onCodeSubmitted: (val) {
                      print("On Code Submitted...");
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                    child: OutlinedButton(
                        onPressed: () async {
                          if (otpKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationCode,
                                          smsCode: otpNo))
                                  .then((value) async {
                                if (value.user != null) {
                                  setState(() {
                                    print(
                                        "data ${FirebaseAuth.instance.currentUser!.displayName}");
                                    fetchSignUpData(
                                        name.text,
                                        mobile.text,
                                        email.text,
                                        password.text,
                                        referral.text,
                                    );
                                    // signUpController.fetchSignUpData(name.text,mobile.text,email.text,password.text,referral.text);
                                  });
                                }

                                // _otp=otp.text;
                                //Navigator.pushNamed(context, "HomePage");
                              });
                            } catch (e) {
                              //  print("error phone validation ${e.toString()}");
                              // FocusScope.of(context).unfocus();
                              // Navigator.canPop(context);
                              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              //Navigator.pop(context);
                              //Fluttertoast.showToast(msg: "Please try again later");
                            }
                            otpKey.currentState!.save();
                            refresh();
                            Navigator.pop(context);

                          }

                          /* print("Dialogue mail :${email.text}");
                      print("upload mobile :${mobile.text}");
                      print("upload name :${name.text}");
                      print("otp is here ${otp.text}");
                      print(" otp data $_otp");*/
                        },
                        child: Text("Submit"))),
              ],
            ),
          );
        });
  }

  verifyNumber(String phone) async {
    await SmsAutoFill().listenForCode();
    SharedPreferences pref=await SharedPreferences.getInstance();
    print("Phone" + phone);
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        verificationCompleted: (credential) async {

          var appSignatureId = await SmsAutoFill().getAppSignature;
          Map sendOtp = {
            "mobile_number": "+91${mobile.text}",
            "app_signature_id": appSignatureId,
          };
          print(sendOtp);

        setState(() {
          otp="${credential.smsCode}";
        });
            pref.setString("otp", "${credential.smsCode}");
            print("Otp:${credential.smsCode}");


        /*  await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              //Fluttertoast.showToast(msg: "Successfully");


              //Navigator.pushNamed(context, "HomePage");

            }
          });*/

          print("otp listen $otp");
          print("Otp no:$otp");

          // print();
        },
        verificationFailed: (FirebaseAuthException e) async {
          Navigator.pop(context);
          Fluttertoast.showToast(msg:"Please try again later");

        },
        codeSent: (String verificationId, int? resendeingToken) {
          if (mounted) {
            setState(() {
              verificationCode = verificationId;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          if (mounted) {
            setState(() {
              verificationCode = verificationId;
            });
          }
        });
    verifyOtp(otp);
  }

  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referral = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SignUpController signUpController = SignUpController();
fetchToken() async{
  await FirebaseMessaging.instance.getToken().then((value){
    setState(() {
      deviceToken=value.toString();
     print("Sign Up Token:$deviceToken");
    });
  });
}
  @override
  void initState() {
    SmsAutoFill().listenForCode();
    controller = ScrollController()
      ..addListener(() {
        setState(() {
          scrollButton();
        });
      });
    fetchToken();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  scrollButton() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        Fluttertoast.showToast(msg: "reach the bottom");
      });
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        Fluttertoast.showToast(msg: "reach the top");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: [

            Positioned(
                top: 0,
                right: -100,
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.orange.shade500,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                      )),
                )),
            Positioned(
                left: -100,
                bottom: 0,
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.orange.shade500,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(200),
                      )),
                )),
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Sign Up", style: Theme.of(context).textTheme.headline4),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: TextFormField(
                            controller: name,
                            keyboardType: TextInputType.text,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                              if (value.trim().length < 8) {
                                return 'Username must be at least 8 characters';
                              }
                              // Return null if the entered username is valid
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              hintText: "Enter your full name",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: TextFormField(
                            controller: email,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email address';
                              }
                              // Check if the entered email has the right format
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              // Return null if the entered email is valid
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: "Enter your email address",
                            ),
                          ),
                        ),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: TextFormField(
                            controller: mobile,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                              if (value.trim().length < 10) {
                                return 'mobile number must be at least 10 digit';
                              }
                              // Return null if the entered password is valid
                              return null;
                            },
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.call),
                              counterText: "",
                              hintText: "Enter your mobile no.",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: TextFormField(
                            controller: password,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: !showPassword,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                              if (value.trim().length < 8) {
                                return 'Password must be at least 8 characters in length';
                              }
                              // Return null if the entered password is valid
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Enter your password",
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  child: Icon(showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            ),
                          ),
                        ),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: TextFormField(
                            controller: referral,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.sticky_note_2),
                              hintText: "Enter your referral code",
                            ),
                          ),
                        ),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: FloatingActionButton.extended(
                            extendedPadding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            onPressed: () {
                              setState(() {
                                if (formKey.currentState!.validate()) {
                                  verifyNumber(mobile.text);
                                  formKey.currentState!.save();
                                }
                              });
                            },
                            label: const Text("Sign Up"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already registered?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignInPage()));
                                  },
                                  child: const Text("Sign In")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
