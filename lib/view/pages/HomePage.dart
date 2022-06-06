import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/SliderController.dart';
import 'package:libertypaints/controller/profileControllers/MainProfileUpdateController.dart';
import 'package:libertypaints/main.dart';
import 'package:libertypaints/model/Service.dart';
import 'package:libertypaints/view/notification/NotificationCounter.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/notification/Notifications.dart';
import 'package:libertypaints/view/pages/ColorVisualization.dart';
import 'package:libertypaints/view/pages/Drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:libertypaints/view/pages/MyOffer.dart';
import 'package:libertypaints/view/pages/Product%20Range.dart';
import 'package:libertypaints/view/pages/Profile/MainProfile.dart';
import 'package:libertypaints/view/pages/Redeem%20Points.dart';
import 'package:libertypaints/view/pages/ReferPainter.dart';
import 'package:libertypaints/view/pages/Training%20Videos/VideoCategoryScreen.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class HomePage extends StatefulWidget {
  final String token;
  const HomePage({Key? key,required this.token}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MainProfileUpdateController mainProfileUpdateController=Get.put(MainProfileUpdateController());
  SliderController sliderController=Get.put(SliderController());
  NotificationCounter notificationCounter=NotificationCounter();

  String count="";
  final colors = const [
    Colors.red,
    Colors.green,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.blue,
    Colors.amber,
  ];
  int currentPosition=0;
  List<String> items=[
    "images/paint1.jpg",
    "images/paint2.jpg",
    "images/paint3.jpg",
  ];
  String username="";




  List<Service> serviceList=[
    Service("My Offer", "assets/gift_box.png",),
    Service("Redeem \nPoints", "assets/price.png"),
    Service("Refer \nPainter", "assets/iconuser.png"),
    Service("Products", "assets/product-range.png"),
    Service("Training \nVideos", "assets/video.png"),
    Service("Color \nVisualization", "assets/filter.png"),
  ];
  
  @override
  void initState() {


    setState(() {
      sliderController.fetchSliderData(widget.token);
      mainProfileUpdateController.fetchMainProfileUpdate(widget.token);


    });
    super.initState();
  }
  @override
  void dispose() {
    sliderController.sliderImage.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      drawer: Drawer(
        child: DrawerWidget(token: widget.token),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration:  const BoxDecoration(
                  color:  Color(0xff2A2550),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Obx((){
                      if(mainProfileUpdateController.mainProfileModel.isEmpty){
                        return const CircularProgressIndicator(color: Colors.transparent);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top:20.0,left:10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${mainProfileUpdateController.mainProfileModel.first.name}",style: TextStyle(color: Colors.white),),
                            Row(

                              children: <Widget>[
                                Badge(
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
                                /*  ValueListenableBuilder(
                               valueListenable: notificationCounterValueNotifer,
                               builder: (context,value,child){



                                //notificationCounterValueNotifer.value=int.parse(value.toString());


                                 return Badge(
                                   showBadge: notificationCounterValueNotifer.value==0?false:true,
                                   badgeContent:  Text("${notificationCounterValueNotifer.value}"),
                                   badgeColor: Colors.white,
                                   position: BadgePosition.topEnd(end: 0,top: 0),
                                   child: IconButton(onPressed: (){

                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetails(token: widget.token)));
                                     notificationCounterValueNotifer.value=0;

                                   }, icon: const Icon(Icons.notifications_outlined,color: Colors.white,size: 28)),
                                 );
                               }),*/

                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: (){

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainProfile(token: widget.token)));
                                  },
                                  child: const CircleAvatar(

                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person,size: 30,color: Colors.black,)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    Obx((){
                      return sliderController.sliderImage.isNotEmpty?
                      CarouselSlider.builder(
                          itemCount: sliderController.sliderImage.length,
                          itemBuilder: (context,index,child){
                            return ImageViewer(imagePath: "${baseUrl+sliderController.sliderImage[index].image}");
                          },
                          options: CarouselOptions(
                            onPageChanged: (index,reason){
                              setState(() {
                                currentPosition=index;
                              });
                            },
                            autoPlay: true,
                            height: 200,
                            aspectRatio: 16/9,
                            enlargeCenterPage: true,
                            viewportFraction: .9,
                            // viewportFraction: 0.83,
                          ),
                      ): CarouselSlider.builder(
                        itemCount: items.length,
                        itemBuilder: (context,index,child){
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage("${items[index]}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          onPageChanged: (index,reason){
                            setState(() {
                              currentPosition=index;
                            });
                          },
                          autoPlay: true,
                          height: 200,
                          aspectRatio: 16/8,
                          enlargeCenterPage: true,
                          viewportFraction: .9,
                          // viewportFraction: 0.83,
                        ),
                      );
                    }),

                    buildIndicator(),


                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 0),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                            itemCount: serviceList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,

                              childAspectRatio: 16/10,
                            ),

                            itemBuilder: (context,index){

                              return InkWell(
                                onTap: (){
                                  print(index);
                                  setState(() {
                                    if(index==0){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOffer(token: widget.token)));
                                    }
                                    else if(index==1){
                                      Navigator.push(context, MaterialPageRoute(builder: (contex)=>RedeemPointsPage(token: widget.token,)));
                                    }
                                    else if(index==2){
                                      Navigator.push(context, MaterialPageRoute(builder: (contex)=>ReferPainter(token: widget.token,)));
                                    }
                                    else if(index==3){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductRange(token: widget.token)));
                                    }
                                    else if(index==4){
                                      Navigator.push(context, MaterialPageRoute(builder: (contex)=>VideoCategoryScreen(token: widget.token,)));
                                    }
                                    else{
                                      print("hiv");
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ColorVisualization(token: widget.token)));
                                    }
                                  });

                                },
                                child: Card(
                                  elevation: 5,

                                  shape: const RoundedRectangleBorder(
                                    borderRadius:  BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),


                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:20.0),
                                            child: Image.asset("${serviceList[index].imagePath}",width: 60,),
                                          ),
                                          Flexible(child: Padding(
                                            padding: const EdgeInsets.only(top:20.0),
                                            child: Text("${serviceList[index].title}"),
                                          )),

                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),

                                            boxShadow: [
                                              BoxShadow(
                                                color: index==0?Colors.orange:index==1?Colors.lightBlue:index==2?Colors.deepPurple:index==3?Colors.green:index==4?Colors.indigo:index==5?Ccolor:Colors.white,

                                              ),
                                            ]
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    )

                  ],
                ),
              ),


            ],
          ),
      ),
      );
  }
  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: currentPosition,
      count: sliderController.sliderImage.isNotEmpty?sliderController.sliderImage.length:items.length,
      effect:CustomizableEffect(
        activeDotDecoration: DotDecoration(
          width: 20,
          height: 5,
          color: Colors.white,
          // rotationAngle: 180,
          // verticalOffset: -10,
          borderRadius: BorderRadius.circular(24),
        ),
        dotDecoration: DotDecoration(
          width: 12,
          height: 12,
          color: Colors.orange,
          borderRadius: BorderRadius.circular(16),
          verticalOffset: 0,
        ),
        spacing: 6.0),
        // activeColorOverride: (i) => colors[i],
        //inActiveColorOverride: (i) => colors[i],),
    );
  }
}
class ImageViewer extends StatelessWidget {
  String imagePath;
  ImageViewer({Key? key,required this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(20),
       image: DecorationImage(
         image: CachedNetworkImageProvider(imagePath),
         fit: BoxFit.cover,
       ),
     ),
    );
  }

}
class NativeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}