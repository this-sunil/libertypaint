import 'package:flutter/material.dart';
import 'package:libertypaints/view/pages/Utility/ServicesPage.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

class ProgramRelatedPage extends StatelessWidget {
  const ProgramRelatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help Center'),backgroundColor: Ccolor,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Program Related',style: TextStyle(
              fontSize: 20
            ),
            ),

            ListView(
              shrinkWrap: true,
              children: [
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('What is Liberty Paint?'),
                  subtitle:  Text('Liberty Paint is Painting Contractor loyalty program which has specically been'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'What is Liberty Paint?', answer: 'Liberty Paint is a painting contractor loyalty program which has specially been designed for our painting contractors in which they accrue point on every purchase of Nerolac products which not only take care of them but theri family also  ',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How Can I become Liberty Paint Contractor?'),
                  subtitle: Text('if you are smart phone user then you can simply download Liberty Paint App'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder:(context)=>ServicesPage(question: 'How Can I become Liberty Paint Contractor?',answer:'.if you are smart phone user then you can simply download Liberty Paint Application from google play store and register yourself to become happy Liberty Paint contractor.if you dont use smart phone then also you can join us by calling toll free no 1800-102-2424' ,)));
                  },

                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('Is there any fee for joining?'),
                  subtitle: Text('No.this program has no fee to  join.'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'Is there any fee for joining?', answer: 'No, this program has no fee to join',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('What are other benefits under Liberty Paint loyalty program?'),
                  subtitle: Text('There are many other benifits like Accidental insurance worth Rs.2lac,child...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'What are other benefits under Liberty Paint loyalty program?', answer: 'There are many other benefit like Accidental insurance worth Rs.2 lac Children scholarship upto Rs.10000/- Health insurance upto Rs.50000/- and many more .you can refer program benefit grid for more information',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How Can I earn Points?'),
                  subtitle: Text('Now you can earn point through various ways as mentioned below...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How Can I earn Points?', answer: 'Now you can earn points through various ways as mentioned below; *By scanning QR code tokens found in Nerolac token eligible products *By refer your Contractor friend *By giving correct answers of quiz run by Nerolac *By attending online trainings conducted by Nerolac * By regular use of Liberty Paint Application',)));
                  },
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
