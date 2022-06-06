import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/Category/ProductCategoryController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/ProductSearchPage.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:provider/provider.dart';

import '../widget/constant.widget.dart';

class ProductRange extends StatefulWidget {
  final String token;
  const ProductRange({Key? key,required this.token}) : super(key: key);

  @override
  State<ProductRange> createState() => _ProductRangeState();
}

class _ProductRangeState extends State<ProductRange> {
  ProductCategoryController productCategoryController=Get.put(ProductCategoryController());
  List<ProductRanges> productList=[
    ProductRanges("Construction Chemical", "images/nerolac-removebg-preview.png"),
    ProductRanges("Exterior Emulsion", "images/house-removebg-preview.png"),
    ProductRanges("Interior Emulsion", "images/interior.jpeg"),
    ProductRanges("Wood Finish", "images/wood1-removebg-preview.png"),
    ProductRanges("Other", "images/nerolaclogo-removebg-preview.png"),
  ];

@override
  void initState() {
   setState(() {
     productCategoryController.fetchProductCategory(widget.token);
   });

    super.initState();
  }
  @override
  void dispose() {
    productCategoryController.productList.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Ccolor,
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
        title: const Text("Product Category",style: const TextStyle(color:Colors.white ),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight:Radius.circular(20)
              ),

            ),
          ),
        ),

      ),

        body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [

           const Center(
             child: Padding(
               padding: EdgeInsets.all(8.0),
               child: Text('Select a Product Category',style: TextStyle(
                 fontSize: 25,
               ),
               ),
             ),
           ),
         Obx((){
           return  productCategoryController.productList.isNotEmpty?GridView.builder(
               shrinkWrap: true,
               itemCount:productCategoryController.productList.length,
               physics: const NeverScrollableScrollPhysics(),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,

               ),
               itemBuilder: (context,index){
                 return InkWell(
                   onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductSearchPage(token:widget.token, categoryKey: productCategoryController.productList[index].key)));
                   },
                   child: Card(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(child: Image.network("${baseUrl+productCategoryController.productList[index].image}",fit: BoxFit.cover)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("${productCategoryController.productList[index].name}"),
                         )
                       ],
                     ),
                   ),
                 );
               }):const Center(child: CircularProgressIndicator());
         }),
         ],
    ),
        ),
    );


  }
}
class ProductRanges{
  final String title;
  final String imagePath;
  ProductRanges(this.title,this.imagePath);
}
