import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:libertypaints/view/pages/LoginPage.dart';
import 'package:libertypaints/view/pages/Screen/SignInPage.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late PageController pageController;
  int currentIndex=0;
  List<Data> data=[
    Data(path: "images/paint.json", title: "Welcome to Liberty Paint"),
    Data(path: "images/qr-scan-code.json", title: "Scan Qr Code"),
    Data(path: "images/rewards.json", title: "Get Rewards"),
    Data(path: "images/colors.json", title: "Getting Started"),
  ];
  fetchCounter(){
    Future.delayed(const Duration(seconds: 5),() {
      currentIndex++;
      if (currentIndex <=3) {
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInExpo,
        );
      }
    });
  }

  @override
  void initState() {
    pageController=PageController(initialPage: currentIndex);
    super.initState();
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(mounted){
      fetchCounter();
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -100,
              top: 0,
              child: Container(
                width: 200,
                height: 100,
                decoration:  BoxDecoration(
                  color: Colors.pink.withOpacity(.8),

                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(200))
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: -100,
              child: Container(
                width: 200,
                height: 100,
                decoration:  BoxDecoration(
                    color: Colors.pink.withOpacity(.8),

                    borderRadius: BorderRadius.only(topLeft: Radius.circular(200))
                ),
              ),
            ),
            PageView.builder(
              physics: BouncingScrollPhysics(),
            itemCount: data.length,
              onPageChanged: (index){
              setState(() {
                currentIndex=index;

              });
              },
              controller: pageController,
              itemBuilder: (context,index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset(data[index].path),
                    ),

                    currentIndex==3?const Text(""):Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Text(data[index].title,style: const TextStyle(color: Colors.black54,fontSize: 18)),
                    ),


                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){
                          setState(() {
                            if(currentIndex>0){
                              currentIndex--;
                            }
                            pageController.animateToPage(currentIndex, duration:const Duration(seconds: 3), curve: Curves.easeInExpo);
                          });
                        }, icon: const Icon(Icons.keyboard_arrow_left_outlined)),
                        IconButton(onPressed: (){
                         setState(() {
                           currentIndex++;
                           pageController.animateToPage(currentIndex, duration:const Duration(seconds: 3), curve: Curves.easeInExpo);
                         });
                        }, icon: const Icon(Icons.arrow_right_alt_outlined)),
                      ],
                    ),*/

                  ],
                );
              }),
           Positioned(
             child: Align(
               alignment: Alignment.bottomCenter,
               child:  Padding(
                 padding: const EdgeInsets.only(bottom:100),
                 child: currentIndex==3?MaterialButton(
                     color:Colors.pink,
                     minWidth:300,
                     height:50,shape:RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(60)
                 ),

                     onPressed: (){
                       setState(() {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignInPage()));
                       });
                     },child: const Text("Getting Started",style: TextStyle(color: Colors.white))):buildIndicator(),
               ),
             ),
           )

          ],
        ),
      ),
    );
  }
  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: currentIndex,
      count: data.length,
      effect:CustomizableEffect(
          activeDotDecoration: DotDecoration(
            width: 20,
            height: 5,
            color: Colors.black,
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
class Data{
  final String path;
  final String title;
  Data({required this.path,required this.title});

}
