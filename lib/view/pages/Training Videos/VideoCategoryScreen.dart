import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/Videos/TrainingVideoController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Training%20Videos/TrainingVideoScreen.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCategoryScreen extends StatefulWidget {
  final String token;
  const VideoCategoryScreen({Key? key,required this.token}) : super(key: key);

  @override
  _VideoCategoryScreenState createState() => _VideoCategoryScreenState();
}

class _VideoCategoryScreenState extends State<VideoCategoryScreen> {
  TrainingVideoController trainingVideoController=Get.put(TrainingVideoController());
  @override
  void initState() {
    // TODO: implement initState
    trainingVideoController.fetchVideosData(widget.token);
    super.initState();
  }
  @override
  void dispose() {
    trainingVideoController.videomodels.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: const Text("My Training"),
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
        return  trainingVideoController.videomodels.isNotEmpty?ListView.builder(
            itemCount: trainingVideoController.videomodels.length,
            itemBuilder: (context,index){
              var videoId=YoutubePlayer.convertUrlToId("${trainingVideoController.videomodels[index].videoLink}");
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TrainingVideoScreen(path: trainingVideoController.videomodels[index].videoLink,token: widget.token,title: trainingVideoController.videomodels[index].title,description: trainingVideoController.videomodels[index].description)));
                },
                child: Card(
                  child:  Column(
                    children: [

                      Image.network("https://img.youtube.com/vi/$videoId/0.jpg",fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${trainingVideoController.videomodels[index].title}"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ReadMoreText(
                          trainingVideoController.videomodels[index].description,
                          trimLines: 2,
                          style: const TextStyle(color: Colors.grey),
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',

                          lessStyle: TextStyle(color: Ccolor),
                          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Ccolor),
                        ),
                        /* secondHalf.isEmpty
                                          ? new Text(firstHalf)
                                          : new Column(
                                        children: <Widget>[
                                          new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                                          new InkWell(
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                new Text(
                                                  flag ? "show more" : "show less",
                                                  style: new TextStyle(color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              setState(() {
                                               showMore(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),*/
                      ),
                    ],
                  ),
                ),
              );
            }):Center(child: CircularProgressIndicator());
      }),

    );
  }
}
