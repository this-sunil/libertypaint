import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
class ProductDetailsPage extends StatefulWidget {
  final String title;
  final String image;
  final String price;
  final String token;
  const ProductDetailsPage({Key? key,required this.title,required this.image,required this.price,required this.token}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: const Text("Product Details"),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
                tag: widget.title,
                child: Image.network("${baseUrl+widget.image}",width: MediaQuery.of(context).size.width,height: 250)),
          ),
         Expanded(
           flex: 5,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 5.0),
             child: Card(
               elevation: 10,
               margin: EdgeInsets.all(0.0),
               shape: const RoundedRectangleBorder(
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(20.0),
                   topRight:  Radius.circular(20.0),
                 ),
               ),
               child: Card(
                 elevation: 10,
                 margin: EdgeInsets.all(0.0),
                 shape: const RoundedRectangleBorder(
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(20.0),
                     topRight:  Radius.circular(20.0),
                   ),
                 ),
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                       child: Row(
                         children: [
                           Expanded(child: Text(widget.title,style: TextStyle(fontSize: 20),)),
                         ],
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal:10.0),
                       child: Row(
                         children: [
                           Text("MRP: \u{20B9}"+widget.price,style: TextStyle(fontSize: 18)),
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
    );
  }
}
