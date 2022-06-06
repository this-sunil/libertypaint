import 'package:flutter/material.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';

import 'ServicesPage.dart';
class ApplicationRelatedPage extends StatelessWidget {
  const ApplicationRelatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor,
        title: Text('Help Center'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Application Related',style: TextStyle(
              fontSize: 20,
            ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Card(
                  child: ListTile(
                    contentPadding:EdgeInsets.all(20),
                    title: Text('How can I Scan QR code token?'),
                    subtitle: const Text('you just need to do the following to Scan QR code token....'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I Scan QR code token?', answer: 'You just need to do the following to scan QR code toke Click scan button located on your home page Scan Token code QR Enter token code manually which is available on the can of paint',)));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text('What if QR code is not visible or not getting Scanned?'),
                    subtitle: Text('you can enter token code manually.if your token is damaged,you can raise a c....'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'What if QR code is not visible or not getting Scanned?', answer: 'you can enter token code manually. if your token is damaged ,you can raise a complaint in the application .to raise a complaint you can upload damaged token image or take a picture useing camera to upload damaged token image.',)));
                    },
                  ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I redeem my points in application?'),
                  subtitle: Text('To Redeem point using pragati application,you should have KYC and Ba...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I redeem my points in application?', answer: 'To Redeem point using pragati application you should have KYC and Bank details approved. you can click on the redeem button located on your home page.select amountt from available slab to redeem using bank transfer or gift  Exchange. for bank transfer please confirm the amount which you have selected to send a bank transfer request for gift exchange confirm the amount which you have selected to redirect to  gift website ',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I change my personal details?'),
                  subtitle: Text('Click on Prfile icon located at the top right corner on your home Page..'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I change my personal details?', answer: '.Click on profile icon located at the top right corner on your home page.Click on show full profile button to view profile and then click on personal Details tab to change personal details .you can change full Name,Email id  Primary and Secondary Mobile number',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I Change my bank details?'),
                  subtitle: Text('Click on profile icon located at the top corner on your home page'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I Change my bank details?', answer: 'Click on Profile icon located at the top right corner on your home page.Click on show full profile button to view profile. Click on bank details tab to view existing bank details . To change bank detail you need to enter IFSC code  Bank Name Account Number Confirm Account Number Account Holder Hame',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I change my language pereference?'),
                  subtitle: Text('for logged in User Click on side menu to view change language tab you can see...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I change my language pereference?', answer: 'For logged in user - Click on side menu to view change lanuage tab you can selected the perferred language and click on update button to continue with updated language perference',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I Change my application password?'),
                  subtitle: Text('Click on Profile icon located at  the top right corner obn your home page...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I Change my application password?', answer: 'Click on icon located at the top right corner on your home page Click on show full profile button to view profile Click on reset password tab to change application password enter new password and confirm password.',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I update my bank account detail?'),
                  subtitle: Text('Click on profile Icon located at the top right corner on your home page'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I update my bank account detail?', answer: 'Click on profile icon located at the top  right corner on your home page Click on show full profile button to view profile Click on bank detail you need to enter IFSC code Bank Name Account Type (CURRENT /SAVING).Account Number,Confirm Account Number Account Holder Name.',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  title: Text('Will I be able to continue this application if change my mobile no?'),
                  subtitle: Text('yes.you will be able to continue this application if you changeyour mobile number'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'Will I be able to continue this application if change my mobile no?', answer: 'Yes ,you will be able to continue this application if you change your mobile number.',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text(' Can I use this application in multiple moblie numbers?'),
                  subtitle: Text('yes. you will be able to use this application in multiple number.All....'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: ' Can I use this application in multiple moblie numbers?', answer: 'Yes you will be able to use this application in multiple mobile number.all the transaction related SMS will be triggered on primary mobile number',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I use app in new device with existing mobile no?'),
                  subtitle: Text('Install Pragati app from play store in new devaice and log in with you registerd cre...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I use app in new device with existing mobile no?', answer: 'Install pragati app from play store in new device and log in with you registed credentials to access the application all the transaction related SMS will be triggered on primary mobile number.',)));
                  },
                ),
                ),
                Card(child: ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Text('How can I raise complaint in application?'),
                  subtitle: Text('Click on side menu to View complans tab...'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServicesPage(question: 'How can I raise complaint in application?', answer: 'Click on side menu to view complains tab you can select error type and complaint details from dropdown to register a complaint in the application',)));
                  },
                ),
                ),

              ],
            )

          ],
        ),
      ),
    );
  }
}