import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class ServicesPage extends StatefulWidget {
  final String question;
  final String answer;
  const ServicesPage({Key? key,required this.question,required this.answer}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  elevation:0,
  title: Text('Help Center'),
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(20),
    child: Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:BorderRadius.only(topRight: Radius.circular(30),topLeft:  Radius.circular(30)),
      ),
    ),
  ),

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.question}',style: TextStyle(
                      fontSize: 20,
                    ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.answer}',style: TextStyle(
                      fontSize: 15
                    ),),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
