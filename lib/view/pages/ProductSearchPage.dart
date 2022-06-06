import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/config.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/Category/ProductSearchController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/ProductDetailsPage.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
class ProductSearchPage extends StatefulWidget {
  final String token;
  final String categoryKey;
  const ProductSearchPage({Key? key,required this.token,required this.categoryKey}) : super(key: key);

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  ProductSearchController productSearchController=Get.put(ProductSearchController());
  int second=0;
  @override
  void initState() {
    productSearchController.fetchProductSearchCategory(widget.token, widget.categoryKey);
    super.initState();
  }
  @override
  void dispose() {
    productSearchController.productSearchList.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
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
      ),
      body: Obx((){
        return productSearchController.productSearchList.isNotEmpty?ListView.builder(
            itemCount: productSearchController.productSearchList.length,
            itemBuilder: (context,index){
              return Card(
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0.0),
                  leading: Hero(
                      tag:productSearchController.productSearchList[index].name,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          minHeight: 260,
                          maxWidth: 104,
                          maxHeight: 264,
                      ),child: Image.network("${baseUrl+productSearchController.productSearchList[index].image}"),)),
                  title: Text("${productSearchController.productSearchList[index].name}",style: const TextStyle(fontSize: 14)),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("\u{20B9}${productSearchController.productSearchList[index].price}"),
                  ),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductDetailsPage(title: productSearchController.productSearchList[index].name, image: productSearchController.productSearchList[index].image, price: productSearchController.productSearchList[index].price,token: widget.token)));
                  },
                ),
              );
            }):const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
