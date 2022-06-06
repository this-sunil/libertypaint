import 'dart:collection';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/model/VideoModels.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:pod_player/pod_player.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class TrainingVideoScreen extends StatefulWidget {
  final String path;
  final String token;
  final String title;
  final String description;
  const TrainingVideoScreen({Key? key,required this.path,required this.token,required this.title,required this.description}) : super(key: key);

  @override
  _TrainingVideoScreenState createState() => _TrainingVideoScreenState();
}

class _TrainingVideoScreenState extends State<TrainingVideoScreen> {

  late Future<void> _initializeVideoPlayerFuture;
  late final PodPlayerController controller;
  String firstHalf="";
  String secondHalf="";
  bool flag = true;
  HashSet hashSet=HashSet();
  List<VideosModel> list=[];
  fetchData() async{
    final res= await http.get(Uri.parse("${baseUrl}api/getTrainingVideosApi"),headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    });
   final models=videosModelFromJson(res.body);
   if(res.statusCode==200){
     if(models.isNotEmpty){
       list.clear();
      setState(() {
        list.addAll(models);
      });
       print("Result $list");
     }
   }
   return list;
  }
  String title="";
  String description="";
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      fetchData();
    });
    controller=PodPlayerController(playVideoFrom: PlayVideoFrom.youtube(widget.path));
    title=widget.title;
    description=widget.description;

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = controller.initialise();
    // Use the controller to loop the video.
  /*  _controller.setLooping(true);
    var id= YoutubePlayer.convertUrlToId(widget.path);
   youtubePlayerController = YoutubePlayerController(
      initialVideoId: "$id",

      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );*/



    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Ccolor,
      title:Text(title),

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

      body: SafeArea(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return  SingleChildScrollView(
                child: Column(
                  children: [
                    PodVideoPlayer(controller: controller,frameAspectRatio: 16/12),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            child: Text("$title"),
                          ),
                        ),
                      ],

                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ReadMoreText(
                        description,
                        trimLines: 2,
                        style: TextStyle(color: Colors.grey),
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',

                        lessStyle: TextStyle(color: Ccolor),
                        moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Ccolor),
                      ),
                    ),
                   ListView.builder(
                     shrinkWrap: true,
                       physics: const BouncingScrollPhysics(),
                       itemCount: list.length,
                       itemBuilder: (context,index){

                       var videoId=YoutubePlayer.convertUrlToId(widget.path);
                         return InkWell(
                           onTap: (){
                             setState(() {
                               controller.changeVideo(playVideoFrom: PlayVideoFrom.youtube(list[index].videoLink));
                               title=list[index].title;
                               description=list[index].description;
                             });
                           },
                           child: Card(
                             child: Row(
                               children: [
                                 Expanded(
                                   child: Container(
                                     width: 100,
                                       height:100,
                                       decoration: BoxDecoration(
                                         image:DecorationImage(
                                           image: NetworkImage("https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(list[index].videoLink)}/0.jpg"),fit: BoxFit.cover),
                                         ),
                                       ),
                                 ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${list[index].title}"),
                                      ),

                                    ],
                                  ),
                                )
                               ],
                             ),
                           ),
                         );
                       }),
                  ],
                ),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
