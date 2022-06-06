import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/controller/ContactUsController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Screen/CurvePainter.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
class ContactUs extends StatefulWidget {
  final String token;
  const ContactUs({Key? key,required this.token}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  ContactUsController contactUsController=Get.put(ContactUsController());
  GlobalKey<FormState> contactKey=GlobalKey();
  late TextEditingController mobile;
  late TextEditingController note;
  @override
  void initState() {
    mobile=TextEditingController();
    note=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    mobile.clear();
    note.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: const Text('Contact US'),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Form(
              key: contactKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    alignment:Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size.fromHeight(150),
                        painter: CurvePainter(),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        elevation:5,
                        shape:StadiumBorder(),
                        child:  CircleAvatar(
                            maxRadius:60,
                            backgroundColor: Colors.white,
                            child: Image.asset('images/Contactus.png')),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30),
                    child: TextFormField(
                      controller: mobile,
                      decoration: const InputDecoration(
                        counterText: "",
                        prefixIcon: Icon(Icons.call),
                        hintText: "Enter your Mobile Number",
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (val){
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp =  RegExp(pattern);
                        if (val!.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        else if (!regExp.hasMatch(val)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30),
                    child: TextFormField(
                      controller: note,
                      decoration: const InputDecoration(
                        hintText: "Enter your Messages",
                        prefixIcon: Icon(Icons.message),

                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      validator: (val){
                        if(val!.isEmpty){
                          return "Please enter your message";
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Image.asset("images/contact.jpg"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 40),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                     decoration:BoxDecoration(
                       borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                          child: const Text("Send"),
                          onPressed: (){
                            setState(() {
                              if(contactKey.currentState!.validate()){
                                contactUsController.postContact(widget.token, mobile.text, note.text);
                                contactKey.currentState!.save();
                              }
                              mobile.clear();
                              note.clear();
                            });
                      }),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
