import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Training%20Videos/VideoCategoryScreen.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
class MyPortfolio extends StatefulWidget {
  final String token;
  const MyPortfolio({Key? key,required this.token}) : super(key: key);

  @override
  State<MyPortfolio> createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  List<TrainingVideos> trainingVideos=[
    TrainingVideos("Wood Finish", "images/R11.jpeg"),
    TrainingVideos("Decoration Paints", "images/R12.jpg"),
    TrainingVideos("Construction Chemical", "images/R21.jpg"),
    TrainingVideos("New Trends", "images/R31.jpg"),
    TrainingVideos("Others", "images/R22.jpg"),
  ];
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Ccolor,
        title: const Text('My Trainings'),
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Select a Video Category',style: TextStyle(
                fontSize: 18,
              ),
        ),
            ),
           GridView.builder(
             shrinkWrap: true,
               itemCount: trainingVideos.length,
               physics: NeverScrollableScrollPhysics(),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2
               ), itemBuilder: (context,index){
                 return  InkWell(
                   onTap: (){
                     setState(() {
                       if(index==0){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCategoryScreen(token: widget.token,)));
                       }
                     });
                   },
                   child: Card(
                     elevation: 5,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Expanded(

                             child: Container(
                                 decoration:BoxDecoration(
                                   image: DecorationImage(

                                     image: AssetImage(

                                       trainingVideos[index].imagePath,

                                     ),
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                             )),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(trainingVideos[index].title),
                         ),
                       ],

                     ),
                   ),
                 );
           })
           /* SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('images/R11.jpeg',fit: BoxFit.cover,height: 200),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Wood Finish'),
                          ),

                        ],

                      ),
                    ),

                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('images/R12.jpg',fit: BoxFit.cover,height: 200),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Decoration Paints'),
                          ),
                        ],

                      ),
                    ),
                  ),


                    ],
                  ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('images/R31.jpg',fit: BoxFit.cover,height: 200),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('New Trends'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('images/R21.jpg',fit: BoxFit.cover,height: 200),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Construction Chemical'),
                          ),

                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Image.asset(

                          'images/R22.jpg',fit: BoxFit.cover,

                        height: 200,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Others'),
                      )
                    ],
                  ),
                ),
              ),
            )*/

          ],
        ),

            ),
        );
  }
}
class TrainingVideos{
  final String title;
  final String imagePath;
  TrainingVideos(this.title,this.imagePath);
}
