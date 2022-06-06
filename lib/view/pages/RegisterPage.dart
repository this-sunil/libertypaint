import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/Credential/SignUpController.dart';
import 'package:libertypaints/view/main_Screen.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
class SignUp extends StatefulWidget {

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

bool showPassword = false;

class _SignUpState extends State<SignUp> {
  String verificationCode = "";
  TextEditingController Otp = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();
  late String otp="";

  refresh() async {

    otp="";
    /* name.clear();
    mobile.clear();
    email.clear();*/
  }
  fetchSignUpData(String name,String mobile,String email,String password,String referal) async{
   // SharedPreferences pref=await SharedPreferences.getInstance();
    final resp=await http.post(Uri.parse("${baseUrl}api/userReisterApi"),headers: {
      "accept":"application/json",
    },
      body: {
        "name":name,
        "mobile":mobile,
        "email":email,
        "password":password,
        "referral_code":referal,

      },
    );
    Map<String,dynamic> maps=jsonDecode(resp.body);
    if(resp.statusCode==200){
      //signUpToken.clear();
      Fluttertoast.showToast(msg: maps["message"]);
     // pref.setString("token123", maps["token"]);
      if(maps["token"]!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(token: maps["token"])));
      }
     // signUpToken.add(maps["token"]);
      //print("Token Data ${signUpToken[0]}");
      //print("Print signUp Token:${signUpToken[0].toString()}");
    }
    else{
      Fluttertoast.showToast(msg: "${maps["message"]}");
    }
  }
  verifyOtp(String otpNo) {
    print("Otp no:$otpNo");
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
                    onCodeChanged: (code){
                      setState(() {
                        otpNo=code.toString();
                      });
                    },
                    onCodeSubmitted: (val){

                      print("On Code Submitted...");
                      
                    },
                  ),
                ),

                SizedBox(height: 10),
                Center(
                    child: OutlinedButton(
                        onPressed: () async{
                          if (otpKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationCode,
                                          smsCode: otpNo))
                                  .then((value) async {


                                if(value.user != null) {
                                  setState(() {
                                    print("data ${FirebaseAuth.instance
                                        .currentUser!.displayName}");
                                    fetchSignUpData(
                                        name.text, mobile.text, email.text,
                                        password.text, referral.text);
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
                              Navigator.canPop(context);
                            }
                            otpKey.currentState!.save();
                            refresh();
                           // Navigator.canPop(context);

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
    print("Phone"+phone);
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        verificationCompleted: (credential) async {

          var appSignatureId=await SmsAutoFill().getAppSignature;
          Map sendOtp={
            "mobile_number":"+91${mobile.text}",
            "app_signature_id":appSignatureId,
          };
          print(sendOtp);
          setState(() {
            otp="${credential.smsCode}";
            print("Otp:${credential.smsCode}");

          });
          await SmsAutoFill().listenForCode();
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print("loggen In");



              //Navigator.pushNamed(context, "HomePage");

            }

          });

          print("otp listen $otp");
         // print();



        },


        verificationFailed: (FirebaseAuthException e) async {
          print("phone validation error:${e.message}");
          Fluttertoast.showToast(msg: '${e.message}');
          Navigator.canPop(context);
        },
        codeSent: (String verificationId, int? resendeingToken) {
        if(mounted){
          setState(() {
            verificationCode = verificationId;
          });
        }
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
         if(mounted){
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

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    super.initState();
  }
@override
  void dispose() {
  SmsAutoFill().unregisterListener();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final inputName = TextFormField(
        controller: name,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value){
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
          hintText: "Full Name",
          contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        ));
    final inputNumber = TextFormField(
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
          fillColor: Colors.white,
          filled: true,
          counterText: "",
          hintText: "Mobile Number",
          contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        ));
    final inputEmail = TextFormField(
        controller: email,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your email address';
          }
          // Check if the entered email has the right format
          if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          // Return null if the entered email is valid
          return null;
        },

        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Email",
          contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        ));
    final inputPassword = TextFormField(
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
          hintText: "Password",
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off))),
    );
    final referal = TextFormField(
      controller: referral,
      keyboardType: TextInputType.text,

      decoration: const InputDecoration(
        hintText: "Referral",
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        fillColor: Colors.white,
        filled: true,
      ),
    );
    final signUpButton = MaterialButton(
      onPressed: () {
        if(formKey.currentState!.validate()){
         verifyNumber(mobile.text);
         formKey.currentState!.save();
        }

        },
      child: const Text('Sign Up',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      height: 50,
      minWidth: 250,
      color: Ccolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
    return Scaffold(
      backgroundColor: Colors.brown.shade500,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60,left: 10,right: 10,bottom: 60),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 30, color: Ccolor),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: inputName,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: inputNumber,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: inputEmail,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: inputPassword,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: referal,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30,left:10.0,right: 10),
                        child: signUpButton,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account ?",

                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Log In",
                                style: TextStyle(fontSize: 20),
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
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 40,
      child: TextFormField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',

          //hintStyle: TextStyle(color: Colors.black, fontSize: 10.0)
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
