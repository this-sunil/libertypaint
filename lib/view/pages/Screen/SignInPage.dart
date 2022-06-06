import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/Credential/SignInController.dart';
import 'package:libertypaints/view/pages/Screen/SignUpPage.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController phoneController;
  late TextEditingController _passController;
  bool _showPassword = false;
  String deviceToken="";
  SignInController signInController = Get.put(SignInController());
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  fetchToken() async{
    await FirebaseMessaging.instance.getToken().then((value){
      setState(() {
        deviceToken=value.toString();
       print("Sign In Token:$deviceToken");
      });
    });
  }
  @override
  void initState() {
    phoneController = TextEditingController();
    _passController = TextEditingController();
    fetchToken();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.clear();
    _passController.clear();
    super.dispose();
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
                child: Form(
                  key: loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign In",
                          style: Theme.of(context).textTheme.headline4),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 20),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
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
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.call),
                            hintText: "Enter your mobile no.",
                            counterText: "",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 20),
                        child: TextFormField(
                          controller: _passController,
                          keyboardType: TextInputType.text,
                          obscureText: !_showPassword,
                          cursorColor: Ccolor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Enter your password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                  //
                                },
                                child: Icon(_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FloatingActionButton.extended(
                          extendedPadding:
                              const EdgeInsets.symmetric(horizontal: 100),
                          onPressed: () {
                            setState(() {
                              if (loginKey.currentState!.validate()) {
                                // print(phoneController.text);
                                if (phoneController.text.isNotEmpty &&
                                    _passController.text.isNotEmpty) {
                                  signInController.fetchSignInData(
                                      phoneController.text,
                                      _passController.text,
                                      context,deviceToken);
                                }
                                loginKey.currentState!.save();
                              }
                            });
                          },
                          label: const Text("Sign In"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Create an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()));
                                },
                                child: const Text("Sign Up")),
                          ],
                        ),
                      ),
                    ],
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
