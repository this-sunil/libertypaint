import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/profileControllers/BankDetailsController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BankDetailsPage extends StatefulWidget {
  final String token;
  const BankDetailsPage({Key? key,required this.token}) : super(key: key);

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  late TextEditingController ifsc;
  late TextEditingController bankName;
  late TextEditingController accountType;
  late TextEditingController upipin;
  late TextEditingController accountNumber;
  late TextEditingController confirmAccountNo;
  late TextEditingController accountHolderName;
  List<String> accountTypeList=["Please Select Account Type","Saving Account","Current Account"];
  String selectedValue="current";
  BankDetailsController bankDetailsController=Get.put(BankDetailsController());
  GlobalKey<FormState> bankDetailsKey=GlobalKey<FormState>();
  ImagePicker imagePicker=ImagePicker();
  String selected="select";
  File? imageFile;
  bool spinner=false;
  pickImage() async{
    final picker=await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
     if(picker!=null){
       imageFile=File(picker.path).absolute;
     }
    });
    return imageFile;
  }
  bool check=false;
  bool passbook=false;
   var stream;
  postBankDetailsData(String token,String ifscCode,String bankName,String accountType,String accountHolderName,String accountNumber,bool passbook,bool check) async{
    setState(() {
      spinner = true;
    });

    int length=0;
    if(imageFile!=null){
      stream=http.ByteStream(imageFile!.openRead());
      stream.cast();
      length=await imageFile!.length();
    }
    var request=http.MultipartRequest(
        "POST", Uri.parse("${baseUrl}api/userBankDetailsUpdateApi"));
    request.headers.addAll({
      "accept":"application/json",
      'Authorization': 'Bearer $token',
    });

    request.fields["bank_ifsc"]=ifscCode;
    request.fields["bank_name"]=bankName;
    request.fields["bank_acc_type"]=accountType;
    request.fields["bank_acc_holder_name"]=accountHolderName;
    request.fields["bank_acc_no"]=accountNumber;
    if(imageFile!=null){
     if(passbook){
       print("passbook $passbook");
       request.fields["bank_passbook"]=imageFile!.path;
     }
     else{
       print("check $check");
       request.fields["bank_checkbook"]=imageFile!.path;
     }
    }
    if(imageFile!=null){
     if(passbook){
       var multipart =
       http.MultipartFile("bank_passbook", stream, length, filename: imageFile!.path);
       print("passbook image loaded:$multipart");
       request.files.add(multipart);
     }
     else{

       var multipart =
       http.MultipartFile("bank_checkbook", stream, length, filename: imageFile!.path);
       print("Checkbook image loaded:$multipart");
       request.files.add(multipart);
     }
    }

    var res = await request.send();

    if (res.statusCode == 200) {
      http.Response response=await http.Response.fromStream(res);
      Map<String,dynamic> result=jsonDecode(response.body);
      Fluttertoast.showToast(msg: result["message"]);
      print("Response Bank Details:${response.statusCode}");
      setState(() {
        spinner = false;
        imageFile=null;
      });
    } else {
      Fluttertoast.showToast(msg:"failed");
      spinner = false;
    }
   /* request.fields[""]=;
    request.fields[""]=;
    request.fields[""]=;*/
  }
  late String bankPassbook="";
  late String checkbook="";
  List<String> accountTypes=[
    "current",
    "saving",
  ];
late SharedPreferences pref;
  fetchData() async{
     pref=await SharedPreferences.getInstance();
      setState(() {
        ifsc.text=pref.getString("ifsc").toString();
        bankName.text=pref.getString("bankName").toString();
        accountType.text=pref.getString("accountType").toString();
        accountHolderName.text=pref.getString("bankHolderName").toString();
        accountNumber.text=pref.getString("bankAccountNo").toString();
        confirmAccountNo.text=pref.getString("bankAccountNo").toString();
        upipin.text=pref.getString("upi_pin").toString();
        bankPassbook=pref.getString("bankPassbook").toString();
        checkbook=pref.getString("bankCheckbook").toString();
      });


  }
  @override
  void initState() {
    ifsc=TextEditingController();
    bankName=TextEditingController();
    accountType=TextEditingController();
    upipin=TextEditingController();
   accountNumber=TextEditingController();
   confirmAccountNo=TextEditingController();
    accountHolderName=TextEditingController();
   if(mounted){
     setState(() {
       bankDetailsController.fetchBankDetails(widget.token);

     });
   }
    super.initState();
  }
  @override
  void dispose() {
    bankDetailsController.bankDetails.clear();
    ifsc.clear();
    bankName.clear();
    accountType.clear();
    accountNumber.clear();
    confirmAccountNo.clear();
    upipin.clear();
    bankPassbook="";
    checkbook="";
    pref.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    fetchData();
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(

      appBar: AppBar(
        elevation: 0,


        backgroundColor: Ccolor,
        title: const Text("Bank Details"),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child:
          Container(
            height: 20,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight:Radius.circular(20)
                ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body:Obx((){
        if(bankDetailsController.bankDetails.isNotEmpty){
          return ModalProgressHUD(
            inAsyncCall: spinner,
            child: Form(
              key: bankDetailsKey,
              child: SingleChildScrollView(
                child:
                Column(
                  children: <Widget>[

                    Card(
                      elevation: 0,

                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: ifsc,
                              decoration: const InputDecoration(
                                labelText: "IFSC Code",
                              ),
                              validator: (val){
                                if(val!.isEmpty){
                                  return "please enter your ifsc code";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: bankName,
                              decoration: const InputDecoration(
                                labelText: "Bank Name",
                              ),
                              validator: (val){
                                if(val!.isEmpty){
                                  return "please enter your bank name";
                                }
                                return null;
                              },
                            ),

                          ),
                          Padding(
                            padding:const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              selectedItemBuilder: (BuildContext context){
                                return accountTypes.map((String value) {
                                  return Text(
                                      value,
                                      style: const TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold
                                      )
                                  );
                                }).toList();
                              },
                              value: accountType.text=="current"?"current":"saving",
                              items: accountTypes.map((e){
                                return DropdownMenuItem(
                                  value: e,
                                  child:Text(e),

                                );
                              }).toList(),
                              onChanged: (Object? value) {
                                setState(() {
                                  accountType.text=value.toString();
                                  print(accountType.text);
                                });
                              },
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: accountNumber,
                              decoration: const InputDecoration(
                                labelText: "Account Number",
                              ),
                              validator: (val){
                                if(val!.isEmpty){
                                  return "please enter your account No.";
                                }
                                return null;
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: confirmAccountNo,
                              decoration:  InputDecoration(
                                labelText: "Confirm Account Number",
                              ),
                              validator: (val){

                                if(val!.isEmpty){
                                  return "please confirm your account number";
                                }
                                else if(val!=accountNumber.text){
                                  return "account no. doesn't match";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: upipin,
                              decoration: const InputDecoration(
                                labelText: "UPI Id",
                              ),
                              /* validator: (val){
                            if(val!.isEmpty){
                              return "please enter your UPI Pin";
                            }
                            return null;
                          },*/
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: accountHolderName,
                              decoration: const InputDecoration(
                                labelText: "Account Holder Name",
                              ),
                              validator: (val){
                                if(val!.isEmpty){
                                  return "please enter your account holder name";
                                }
                                return null;
                              },
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Submit any 1 for verification",
                            ),
                          ),

                          RadioListTile(
                              title: const Text("Passbook"),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "passbook", groupValue: selected, onChanged: (val){
                            setState(() {
                              imageFile=null;
                              // Fluttertoast.showToast(msg: "No image selected for passbook");
                              passbook=true;
                              check=false;
                              selected=val.toString();
                              print(selected);
                            });
                          }),
                          RadioListTile(

                              title: const Text("Check"),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "check", groupValue: selected, onChanged: (value){
                            setState(() {
                              imageFile=null;
                              // Fluttertoast.showToast(msg: "No image selected for checkbook");
                              check=true;
                              passbook=false;
                              selected=value.toString();
                              print(selected);
                            });
                          }),
                          passbook?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: imageFile==null?DottedBorder(
                              radius:const Radius.circular(5.0),
                              dashPattern: [5,4],
                              borderType: BorderType.RRect,

                              child:Stack(children: [

                                Image.asset("images/upload_image.jpg"),
                                Positioned(
                                    top: 50,
                                    left: 50,
                                    child: FloatingActionButton(
                                      heroTag: "Add",
                                      mini: true,
                                      onPressed: () {
                                        setState(() {
                                          pickImage();
                                        });

                                      },child: Icon(Icons.add),)),

                              ]),

                            ):Image.file(imageFile!.absolute),
                          ):check?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: imageFile==null?DottedBorder(
                              radius:const Radius.circular(5.0),
                              dashPattern: [5,4],
                              borderType: BorderType.RRect,

                              child:Stack(children: [

                                Image.asset("images/upload_image.jpg"),
                                Positioned(
                                    top: 50,
                                    left: 50,
                                    child: FloatingActionButton(
                                      heroTag: "Add",
                                      mini: true,
                                      onPressed: () {
                                        setState(() {
                                          pickImage();
                                        });

                                      },child: Icon(Icons.add),)),

                              ]),

                            ):Image.file(imageFile!.absolute),
                          ):Container(),
                          const SizedBox(height: 5),

                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                child: OutlinedButton(
                                  onPressed: () {
                                    print(widget.token);
                                    print(ifsc.text);
                                    print(bankName.text);
                                    print(accountType.text);
                                    print(accountHolderName.text);
                                    print(accountNumber.text);
                                    //print(widget.token);
                                    if(bankDetailsKey.currentState!.validate()){
                                      setState(() {
                                        if(selected=="select" || imageFile==null){
                                          if(selected=="select"){
                                            Fluttertoast.showToast(msg: "Please Select any one for verification");
                                          }
                                          else if(imageFile==null){
                                            Fluttertoast.showToast(msg: "Please select an image");
                                          }
                                        }
                                        else{
                                          postBankDetailsData(widget.token,ifsc.text,bankName.text,accountType.text,accountHolderName.text,accountNumber.text,passbook,check);
                                          bankDetailsKey.currentState!.save();
                                        }
                                      });

                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Ccolor),

                                  ),
                                  child: const Text("Done",style: TextStyle(color: Colors.white),),
                                ),
                              )
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
