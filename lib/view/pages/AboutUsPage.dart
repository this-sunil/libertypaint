import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/AboutUsPageController.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html;
import 'package:provider/provider.dart';
class AboutUsPage extends StatefulWidget {
  final String token;
  const AboutUsPage({Key? key,required this.token}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  AboutUsPageController aboutUsPageController=Get.put(AboutUsPageController());
  ScrollController scrollController = ScrollController();
  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 256.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 96.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: new FloatingActionButton(
          backgroundColor: Ccolor,
          onPressed: () {
            setState(() {});
          },
          elevation: 0,
          child: new Icon(Icons.mail),
        ),
      ),
    );
  }

  @override
  void initState() {
    scrollController.addListener(() => setState(() {}));
    setState(() {
      aboutUsPageController.fetchAboutData(widget.token);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(

      body:Obx((){
        return  aboutUsPageController.list.isNotEmpty?Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(

                  backgroundColor: Ccolor,
                  expandedHeight: 256,
                  title: const Text("About Us"),
                  floating: true,
                  pinned: true,
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
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      '${baseUrl+aboutUsPageController.list[0].image}',
                      height: MediaQuery.of(context).size.height,

                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  "${aboutUsPageController.list[0].title}",
                                  style: TextStyle(fontSize: 20, color: Ccolor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text:  TextSpan(children: [
                                    TextSpan(
                                      text: "${html.parse(aboutUsPageController.list[0].description).body!.text}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ])),
              ],
            ),
            _buildFab(),
          ],
        ): NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
             SliverAppBar(
              backgroundColor: Ccolor,
              title:  const Text("About Us"),
            ),
          ];
        }, body: const Center(child: CircularProgressIndicator()));
      }),
    );
  }
}
