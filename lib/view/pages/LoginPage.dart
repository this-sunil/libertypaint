import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/Credential/SignInController.dart';
import 'package:libertypaints/view/pages/RegisterPage.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

bool _showPassword = false;

class _LoginPageState extends State<LoginPage> {
  late TextEditingController phoneController;
  late TextEditingController _passController;
  SignInController signInController = Get.put(SignInController());

  //controller: _phoneController
  @override
  void initState() {
    phoneController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.clear();
    _passController.clear();
    super.dispose();
  }

  final forgerPasswordButton = TextButton(
    onPressed: () {},
    child: const Text(
      "Forget Password?",
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade500,
      body: Form(
        key: loginKey,
        child: Center(
          child: SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 150),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10),
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
                          fillColor: Colors.white,
                          counterText: "",
                          hintText: "Mobile Number",
                        ),
                        // controller: _phoneController
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10),
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
                            iconColor: Ccolor,
                            focusColor: Ccolor,
                            hintText: "Password",
                            fillColor: Colors.white,
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
                        // controller: _passController,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        forgerPasswordButton,
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          if (loginKey.currentState!.validate()) {
                            // print(phoneController.text);
                            if (phoneController.text.isNotEmpty &&
                                _passController.text.isNotEmpty) {
                           /*   signInController.fetchSignInData(
                                  phoneController.text,
                                  _passController.text,
                                  context);*/
                            }
                            loginKey.currentState!.save();
                          }
                        });
                        /*  phoneController.clear();
                  _passController.clear();*/
                      },
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      height: 50,
                      minWidth: 250,
                      color: Ccolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New user ?",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 20, color: Ccolor),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
