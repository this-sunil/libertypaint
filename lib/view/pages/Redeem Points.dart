import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/RedeemPointController.dart';
import 'package:libertypaints/controller/RedeemPointListController.dart';
import 'package:libertypaints/controller/ScanController.dart';
import 'package:libertypaints/controller/profileControllers/BankDetailsController.dart';
import 'package:libertypaints/model/Amount.dart';
import 'package:http/http.dart' as http;
import 'package:libertypaints/model/RedeemPointListModel.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:provider/provider.dart';
import '../widget/constant.widget.dart';
class RedeemPointsPage extends StatefulWidget {
  final String token;
  const RedeemPointsPage({Key? key,required this.token}) : super(key: key);

  @override
  State<RedeemPointsPage> createState() => _RedeemPointsPageState();
}

class _RedeemPointsPageState extends State<RedeemPointsPage> {
  ScanController scanController=Get.put(ScanController());
  RedeemPointController redeemPointController=Get.put(RedeemPointController());
  HashSet<RedeemPointListModel> selectItem=HashSet();
  RedeemPointListController redeemPointListController=Get.put(RedeemPointListController());
  bool flag=false;
  List<Amount> amountList=[

  ];
  void multipleSelection(List<RedeemPointListModel> amount,int index) async{

     if(selectItem.length==2){
       selectItem.remove(amount[index]);
     }
     else{
        selectItem.clear();
        selectItem.add(amount[index]);
     }

    setState(() {

    });
  }
  BankDetailsController bankDetailsController=Get.put(BankDetailsController());
  fetchUpiPin() async{
   bankDetailsController.fetchBankDetails(widget.token);
  }
  @override
  void initState() {
    scanController.fetchScanData(widget.token);
    redeemPointListController.fetchRedeemPointList(widget.token);

    fetchUpiPin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        elevation: 0,
        backgroundColor: Ccolor,
        title: const Text("Redeem Points"),
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
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Column(

            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx((){
                        return scanController.userPointsList.isNotEmpty?Text("${scanController.userPointsList[0].walletpoints}",style: TextStyle(fontSize: 30,color: Colors.white)):Center(child: CircularProgressIndicator());
                      }),
                      Text("pts ",style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Text("Balance Points",style: TextStyle(color: Colors.white),),

                ],
              ),
              SizedBox(height: 50,),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                      topRight:Radius.circular(20)
                  ),

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.warning_amber_outlined,size: 15,color: Colors.red,),
                        Text("Update KYC and Bank details for points redemption",style: TextStyle(fontSize: 10),),
                      ],
                    ),
                    Divider(),

                    Text("Select Value Amount To Redeem",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Ccolor),),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body:Obx((){
        return redeemPointListController.redeemPointListModel.isNotEmpty?ListView.builder(
            itemCount: redeemPointListController.redeemPointListModel.length,
            itemBuilder: (context,index){
              return  Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Card(

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                    onTap: (){
                      flag=true;

                      multipleSelection(redeemPointListController.redeemPointListModel,index);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You are selected ${selectItem.first.points} points and ${selectItem.first.money.replaceAll(".00", "")} Rupees")));
                    },
                    leading:flag?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                          visible:flag,
                          child: selectItem.contains(redeemPointListController.redeemPointListModel[index])?const Icon(Icons.check,color: Colors.green):const Text("")),
                    ):null,
                    title:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${redeemPointListController.redeemPointListModel[index].points} pts"),
                          const Text("="),
                          Text("${redeemPointListController.redeemPointListModel[index].money} \u{20B9}")
                        ],
                      ),
                    ) ,
                  ),
                ),
              );
            }):const Center(child: CircularProgressIndicator(),);
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Ccolor,
        label:Text( "Direct Bank Transfer"),
        onPressed: (){
          print("Points:${selectItem.first.points}");
          print("Rupees:${selectItem.first.money}");

          redeemPointController.fetchRedeemPointData(widget.token,selectItem.first.points.toString(), selectItem.first.money.toString(),context);
        },
       // child: Text("Direct Bank Transfer",style: TextStyle(color: Ccolor),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}
