import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/Complaint/ComplainHistoryController.dart';
import 'package:libertypaints/controller/Complaint/ComplaintDetailsController.dart';
import 'package:libertypaints/controller/Complaint/ErrorDetailsController.dart';
import 'package:libertypaints/model/ComplaintModel/ComplaintDetailsModel.dart';
import 'package:libertypaints/model/ComplaintModel/ErrorDetailsModel.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
class ComplaintPage extends StatefulWidget {
  final String token;
  const ComplaintPage({Key? key,required this.token}) : super(key: key);

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> with SingleTickerProviderStateMixin{
  late TabController complaintController;
  ErrorDetailsController errorDetailsController=Get.put(ErrorDetailsController());
  ComplaintDetailsController complaintDetailsController=Get.put(ComplaintDetailsController());
  ComplainHistoryController complainHistoryController=Get.put(ComplainHistoryController());
  int currentIndex=0;
  String first="";
  bool spinner=false;



  String second="";
  TextEditingController message=TextEditingController();
  bool selectToken=false;
  bool otherToken=false;
  ImagePicker picker=ImagePicker();
  File? pickFile;
  late GlobalKey<FormState> complainKey;

  List<String> errList=[


  ];
  List<String> complaintList=[
  ];

  pickComplaintImage() async{
    final selectFile=await picker.pickImage(source: ImageSource.gallery);
    if(selectFile!=null){
      setState(() {
       pickFile=File(selectFile.path).absolute;
      });
    }
    print(selectFile!.path);
    return pickFile;
  }
  postComplaint(String token,String errDetails,String complaintDetails,String message) async{
    setState(() {
      spinner=true;
    });
    var stream;
    var multipart;
    int length=0;
    if(pickFile!=null){
      stream=http.ByteStream(pickFile!.openRead());
      stream.cast();
      length=await pickFile!.length();
    }
    var request=http.MultipartRequest(
        "POST", Uri.parse("${baseUrl}api/addNewComplain"));
    request.headers.addAll({
      "accept":"application/json",
      'Authorization': 'Bearer $token',
    });
    request.fields["error_id"]=errDetails;
    request.fields["complain_detail_id"]=complaintDetails;
    request.fields["image"]="${pickFile!.path}";
   if(message.isNotEmpty){
     request.fields["description"]=message;
   }


     multipart =
     http.MultipartFile("image", stream, length, filename: pickFile!.path);
     print("image loaded:${multipart.filename}");


    request.files.add(multipart);
    var res = await request.send();

    if (res.statusCode == 200) {
      http.Response response=await http.Response.fromStream(res);
      Map<String,dynamic> result=jsonDecode(response.body);
      Fluttertoast.showToast(msg: result["message"]);
      print("Response Complaint Details:${response.statusCode}");
      setState(() {
        spinner = false;
        pickFile=null;
        selectToken=true;
      });
    } else {
      Fluttertoast.showToast(msg:"failed");
      spinner = false;
    }

  }
  String dropdownValue = "Encajes";
  @override
  void initState() {

    complaintController=TabController(length: 2, vsync: this);
    complaintDetailsController.complaintList.clear();
    errorDetailsController.fetchErrDetailsData(widget.token);
    complainHistoryController.fetchComplainHistory(widget.token);
    complainKey=GlobalKey<FormState>();

 setState(() {
   print("call the method");
 });
    super.initState();
  }
  @override
  void dispose() {

    errorDetailsController.errDetails.clear();
    complaintDetailsController.complaintList.clear();
    complaintController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title:currentIndex==0? const Text("New Complain"):const Text("My Complain"),
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
        bottom:PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:SizedBox(
            height: 60,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              ),
              margin: EdgeInsets.zero,
              child: TabBar(
                controller: complaintController,
                indicatorColor: Ccolor,
                tabs: const [
                  Tab(child: Text("New Complain",style: TextStyle(color: Colors.black))),
                  Tab(child: Text("My Complain",style: TextStyle(color: Colors.black)))
                ],
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: complaintController,
        children: [

          ModalProgressHUD(
            inAsyncCall: spinner,
            child: Form(
                key: complainKey,
                child: buildNewComplaint()),
          ),
          buildMyComplaint(),
        ],
      ),
      floatingActionButton:currentIndex==0?FloatingActionButton.extended(
        heroTag: "Complain",

          extendedPadding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 50),
          onPressed: (){
            setState(() {
              if(complainKey.currentState!.validate()){
                print(first);
                print(second);
                print(pickFile);
                postComplaint(widget.token,first,second,message.text);
                complainKey.currentState!.save();
                //selectToken=false;
                //otherToken=false;
              }
            });
          },label: const Text("Register Complain")):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget buildNewComplaint(){


    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            child:Obx((){
              if(errorDetailsController.errDetails.isEmpty){

                return
                  DropdownButtonFormField<String>(

                  hint: const Center(child: Text("Please Select Error Type")),
                  validator: (val)=>val!=null?null:"Please Select Error Type",
                  items: errList.map((e){
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (val){
                    setState(() {
                   /*   first=val.toString();

                      print("DropList $val");
                      selectToken=false;
                      otherToken=false;*/
                  /*    if(selectValue=="Token related"){
                        selectToken=true;
                        otherToken=false;
                        print("$selectToken");
                      }
                      else if(selectValue=="Others"){
                        otherToken=true;
                        selectToken=false;
                        print(otherToken);
                      }*/

                    });
                  },
                  decoration: InputDecoration(

                  ),
                );
              }
              return  ButtonTheme(
                alignedDropdown: true,
                
                child: DropdownButtonFormField<ErrorDetailsModel>(

                  hint: const Center(child: Text("Please Select Error Type")),
                  validator: (val)=>val!=null?null:"Please Select Error Type",
                  items: errorDetailsController.errDetails.map((e){

                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.errorName),
                    );
                  }).toList(),
                  onChanged: (val){
                    setState(() {
                     if(val!=null) {
                       first = val.id.toString();


                       print("DropList ${val.errorName}");
                       otherToken = false;
                       if (val.errorName == errorDetailsController.errDetails.first.errorName) {
                         selectToken = true;
                         otherToken = false;
                         print("$selectToken");
                       }
                       else if (val.errorName == errorDetailsController.errDetails.last.errorName) {
                         otherToken = true;
                         selectToken = false;
                         print(otherToken);
                       }
                       if(pickFile!=null){
                         pickFile=null;
                         selectToken=false;
                       }
                       complaintDetailsController.complaintList.clear();
                       complaintDetailsController.fetchComplaintDetailsData(widget.token, val.id);
                     }


                    });
                  },
                  decoration: const InputDecoration(

                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            child: Obx((){
              if(complaintDetailsController.complaintList.isEmpty){
                return DropdownButtonFormField<String>(

                  validator: (value)=>value!=null?null:"Please Select Complaint Details",
                  hint: const Center(child: Text("Please Select Complaint Details")),
                  items: complaintList.map((e){
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value){

                    setState(() {



                    });

                  },
                  decoration: InputDecoration(

                  ),
                );
              }
              return complaintDetailsController.complaintList.isNotEmpty?ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<ComplaintDetailsModel>(


                  validator: (value)=>value!=null?null:"Please Select Complaint Details",
                  hint: const Center(child: Text("Please Select Complaint Details")),
                  items: complaintDetailsController.complaintList.map((e){
                    return DropdownMenuItem<ComplaintDetailsModel>(

                      value: e,
                      child: Text(e.complainDetailName),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      if(value!=null){
                        second=value.id.toString();
                      }
                    });

                  },
                  decoration: InputDecoration(

                  ),
                ),
              ):CircularProgressIndicator();
            }),
          ),
          otherToken?Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            child: TextFormField(
              controller: message,
              decoration: const InputDecoration(
                hintText: "Complaint Description",
              ),
            ),
          ):Container(),
          Padding(
            padding: const EdgeInsets.only(top
                :40,bottom: 50,left: 10,right: 10),
            child: selectToken?DottedBorder(
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
                        selectToken?pickComplaintImage():null;
                      });
                        selectToken=false;
                      },child: Icon(Icons.add),)),

              ]),

            ):pickFile!=null?Image.file(pickFile!.absolute):Image.asset("images/register complaint.jpg"),
          ),


        ],
      ),
    );
  }
  Widget buildMyComplaint(){


    return Obx((){
      if(complainHistoryController.complainList.isEmpty){
        return Center(child: Image.asset("images/no-data.png"));
      }
      return ListView.builder(
          itemCount: complainHistoryController.complainList.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                leading: complainHistoryController.complainList[index].image.isNotEmpty?CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage("${baseUrl+complainHistoryController.complainList[index].image}"),
                ):const CircleAvatar(
                  radius: 25,
                backgroundImage: AssetImage("images/no-data.png"),
               ),
                title: Text("${complainHistoryController.complainList[index].detail}",style: Theme.of(context).textTheme.bodyText1),
                subtitle: Text("${complainHistoryController.complainList[index].description}"),
                trailing: Text("${complainHistoryController.complainList[index].date}"),
              ),
            );
          });
    });
  }
}


