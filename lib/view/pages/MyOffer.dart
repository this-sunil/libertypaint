import 'package:flutter/material.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/Offer/OfferController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../widget/NotificationCounters.dart';
class MyOffer extends StatefulWidget {
  final String token;
  const MyOffer({Key? key, required this.token}) : super(key: key);

  @override
  State<MyOffer> createState() => _MyOfferState();
}

class _MyOfferState extends State<MyOffer> {
  MyOfferController myOfferController=Get.put(MyOfferController());
  @override
  void initState() {
    myOfferController.fetchMyOfferData(widget.token);
    super.initState();
  }
  @override
  void dispose() {
    myOfferController.offerList.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Ccolor,
        title: const Text(
          "My Offers",
          style: const TextStyle(color: Colors.white),
        ),
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
          preferredSize: const Size.fromHeight(30),
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20), topRight: const Radius.circular(20)),
            ),
          ),
        ),
      ),
      body: Obx((){
        return myOfferController.offerList.isNotEmpty?ListView.builder(
            itemCount: myOfferController.offerList.length,
            itemBuilder: (context,index){
              return Card(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                        image: DecorationImage(
                          image: NetworkImage("${baseUrl+myOfferController.offerList[index].image}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(myOfferController.offerList[index].title),
                    ),
                  ],
                ),
              );
            }):const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
