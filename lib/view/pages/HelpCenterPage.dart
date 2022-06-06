import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Utility/ApplicationRelatedPage.dart';
import 'package:libertypaints/view/pages/Utility/ProductRelated.dart';
import 'package:libertypaints/view/pages/Utility/ProgramRelated.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:provider/provider.dart';

class HelpCenterPage extends StatefulWidget {
  final String token;
  const HelpCenterPage({Key? key,required this.token}) : super(key: key);

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: Text('Help Center'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Select a Category',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                leading: Text('Program Related'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProgramRelatedPage()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Text('Application Related'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ApplicationRelatedPage()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Text('Product Related'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductRelatedPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
