import 'package:badges/badges.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:libertypaints/controller/History/MoneyPoint/MoneyHistoryController.dart';
import 'package:libertypaints/controller/History/MoneyPoint/MoneyScanController.dart';
import 'package:libertypaints/controller/History/MoneyPoint/RedeemMoneyHistoryController.dart';
import 'package:libertypaints/controller/History/Royalty%20Point/RedeemHistoryController.dart';
import 'package:libertypaints/controller/History/Royalty%20Point/ScanHistoryController.dart';
import 'package:libertypaints/controller/ScanController.dart';
import 'package:libertypaints/controller/WithDrawAmountController.dart';
import 'package:libertypaints/model/HistoryModel/MoneyRedeemHistoryModel.dart';
import 'package:libertypaints/view/main_Screen.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/Redeem%20Points.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:provider/provider.dart';

import '../widget/constant.widget.dart';

class RewardPage extends StatefulWidget {
  final String token;
  const RewardPage({Key? key, required this.token}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> with TickerProviderStateMixin {
  late TabController tabController;
  late TabController historyController;
  RedeemMoneyHistoryController redeemMoneyHistoryController=Get.put(RedeemMoneyHistoryController());
  WithDrawAmountController withDrawAmountController =
      Get.put(WithDrawAmountController());
  TextEditingController withDrawAmount = TextEditingController();
  MoneyHistoryController moneyHistoryController =
      Get.put(MoneyHistoryController());
  RedeemHistoryController redeemHistoryController =
      Get.put(RedeemHistoryController());
  ScanController scanController = Get.put(ScanController());
  MoneyScanController moneyScanController = Get.put(MoneyScanController());
  ScanHistoryController scanHistoryController =
      Get.put(ScanHistoryController());
  late TabController mainController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    historyController = TabController(length: 2, vsync: this, initialIndex: 0);
    mainController = TabController(length: 2, vsync: this, initialIndex: 0);
    scanController.fetchScanData(widget.token);
    redeemMoneyHistoryController.fetchMoneyRedeemHistory(widget.token);
    redeemHistoryController.fetchRedeemHistory(widget.token);
    scanHistoryController.fetchScanHistoryData(widget.token);
    moneyScanController.fetchScanMoney(widget.token);
    moneyHistoryController.fetchRedeemMoneyHistory(widget.token);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    scanController.userPointsList.clear();
    redeemHistoryController.redeemHistoryList.clear();
    super.dispose();
  }

  Future<bool> backBtn() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainScreen(token: widget.token)));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return WillPopScope(
      onWillPop: backBtn,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Ccolor,
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
          title: const Text(
            "Reward Points",
            style: TextStyle(color: Colors.white),

          ),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      TabBar(
                          indicatorColor: Colors.black,
                          controller: tabController,
                          tabs: [
                            Tab(
                              child: Text(
                                "Royalty Point",
                                style: TextStyle(color: Ccolor),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Money",
                                style: TextStyle(color: Ccolor),
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              )),
        ),
        body: TabBarView(controller: tabController, children: [
          //////////////tab Bar one for Royalty point//////////
          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 60,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        //color: Ccolor,
                        child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Ccolor,
                            ),
                            controller: mainController,
                            tabs: [
                              const Tab(child: const Text("Summary")),
                              const Tab(child: Text("History")),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(controller: mainController, children: [
                        ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Text("Total Royalty Points",
                                  style: const TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //Center(child: Text("Total Redeem Points:0", style: TextStyle(fontSize: 20))),

                            Column(
                              children: [
                                Obx(() {
                                  return scanController
                                          .userPointsList.isNotEmpty
                                      ? Text(
                                          "${scanController.userPointsList[0].walletpoints}",
                                          style: TextStyle(
                                              fontSize: 30, color: Ccolor))
                                      : const Center(
                                          child:
                                              const CircularProgressIndicator());
                                }),
                                const Text("Earned pts"),
                              ],
                            ),
                            const Divider(),

                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                height: 50,
                                width: 250,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(Ccolor)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RedeemPointsPage(
                                                      token: widget.token)));
                                    },
                                    child: const Text("Redeem Now"))),
                          ],
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                //color: Ccolor,
                                child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    indicator: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(30),
                                      color: Ccolor,
                                    ),
                                    controller: historyController,
                                    tabs: [
                                      const Tab(child: Text("Scan History")),
                                      const Tab(
                                          child: const Text("Redeem History")),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: TabBarView(
                                  controller: historyController,
                                  children: [
                                    Obx(() {
                                      return scanHistoryController
                                              .scanHistory.isNotEmpty
                                          ? ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: scanHistoryController
                                                  .scanHistory.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  child: ListTile(
                                                    title: Text(
                                                        "Qr No.:${scanHistoryController.scanHistory[index].qrNumber}"),
                                                    subtitle: Text(
                                                        "${formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [
                                                                  MM
                                                                ]) + "," + formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [
                                                                  yyyy
                                                                ])} at ${scanHistoryController.scanHistory[index].time + " " + formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [am])}  "),
                                                    trailing: Text(
                                                        "+${scanHistoryController.scanHistory[index].points} pts"),
                                                  ),
                                                );
                                              })
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "images/no-data.png"),
                                              ],
                                            );
                                    }),
                                    Obx(() {
                                      return redeemHistoryController
                                              .redeemHistoryList.isNotEmpty
                                          ? ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: redeemHistoryController
                                                  .redeemHistoryList.length,
                                              itemBuilder: (context, index) {
                                                print(redeemHistoryController
                                                    .redeemHistoryList.length);
                                                return Card(
                                                  child: ListTile(
                                                    title: Text(
                                                        "Points:${redeemHistoryController.redeemHistoryList[index].redeemrequest[index].points}"),
                                                    subtitle: Text(formatDate(
                                                            DateTime.parse(
                                                                redeemHistoryController
                                                                    .redeemHistoryList[index]
                                                                    .redeemrequest[index]
                                                                    .date),
                                                            [
                                                              MM
                                                            ]) +
                                                        "," +
                                                        "${formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date), [
                                                              yyyy
                                                            ])} at " +
                                                        redeemHistoryController
                                                            .redeemHistoryList[
                                                                index]
                                                            .redeemrequest[
                                                                index]
                                                            .time +
                                                        " " +
                                                        formatDate(
                                                            DateTime.parse(
                                                                redeemHistoryController
                                                                    .redeemHistoryList[index]
                                                                    .redeemrequest[index]
                                                                    .date),
                                                            [am])),
                                                    trailing: Text(
                                                        redeemHistoryController
                                                                    .redeemHistoryList[
                                                                        index]
                                                                    .redeemrequest[
                                                                        index]
                                                                    .requestStatus ==
                                                                1
                                                            ? "Pending"
                                                            : redeemHistoryController
                                                                        .redeemHistoryList[
                                                                            index]
                                                                        .redeemrequest[
                                                                            index]
                                                                        .requestStatus ==
                                                                    2
                                                                ? "In Process"
                                                                : redeemHistoryController
                                                                            .redeemHistoryList[
                                                                                index]
                                                                            .redeemrequest[
                                                                                index]
                                                                            .requestStatus ==
                                                                        3
                                                                    ? "Complete"
                                                                    : redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus ==
                                                                            4
                                                                        ? "Cancelled"
                                                                        : "",
                                                        style: TextStyle(
                                                            color: redeemHistoryController
                                                                        .redeemHistoryList[
                                                                            index]
                                                                        .redeemrequest[
                                                                            index]
                                                                        .requestStatus ==
                                                                    1
                                                                ? Colors.red
                                                                : redeemHistoryController
                                                                            .redeemHistoryList[
                                                                                index]
                                                                            .redeemrequest[
                                                                                index]
                                                                            .requestStatus ==
                                                                        2
                                                                    ? Colors
                                                                        .pink
                                                                    : redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus ==
                                                                            3
                                                                        ? Colors
                                                                            .green
                                                                        : redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus ==
                                                                                4
                                                                            ? Colors.blue
                                                                            : Colors.white)),
                                                  ),
                                                );
                                              })
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "images/no-data.png"),
                                              ],
                                            );
                                    }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //////////////////tab bar 2 for Money/////////////

          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 60,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        //color: Ccolor,
                        child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Ccolor,
                            ),
                            controller: mainController,
                            tabs: [
                              const Tab(child: const Text("Summary")),
                              const Tab(child: const Text("History")),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(controller: mainController, children: [
                        /*Royalty Point History*/
                        ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Text("Total Money",
                                  style: const TextStyle(fontSize: 20)),
                            ),

                            //Center(child: Text("Total Redeem Points:0", style: TextStyle(fontSize: 20))),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Obx(() {
                                  return moneyScanController
                                          .moneyPoint.isNotEmpty
                                      ? Text(
                                          "\u{20B9} ${moneyScanController.moneyPoint[0]}",
                                          style: TextStyle(
                                              fontSize: 30, color: Ccolor))
                                      : const Center(
                                          child:
                                              const CircularProgressIndicator());
                                }),
                                const Text("Earned money"),
                                const Divider(),
                                //const Center(child: Text("Withdraw Money",style: TextStyle(fontSize: 25),)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                                  child: TextFormField(
                                    controller: withDrawAmount,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Enter your withdraw Amount",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          withDrawAmountController
                                              .withdrawAmountData(widget.token,
                                                  withDrawAmount.text);
                                        });
                                      },
                                      child: const Text("Withdraw Amount")),
                                ),
                              ],
                            ),

                            /* Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                               */ /* Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Training-0 Pts",
                                            style: TextStyle(fontSize: 9),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Purchace-0 Pts",
                                            style: TextStyle(fontSize: 9),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),*/ /*
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            color: Colors.yellow,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Offer Points-0 Pts",
                                            style: TextStyle(fontSize: 9),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Referrals-0 Pts",
                                            style: TextStyle(fontSize: 9),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),*/
                          ],
                        ),
                        /*Money point History*/
                        ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                //color: Ccolor,
                                child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    indicator: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(30),
                                      color: Ccolor,
                                    ),
                                    controller: historyController,
                                    tabs: [
                                      const Tab(child: Text("Scan History")),
                                      const Tab(
                                          child: const Text("Redeem History")),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: TabBarView(
                                  controller: historyController,
                                  children: [
                                    Obx(() {
                                      return moneyHistoryController
                                              .moneyHistoryPoint.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: moneyHistoryController
                                                  .moneyHistoryPoint.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  child: ListTile(
                                                    title: Text(
                                                        "Qr No.:${moneyHistoryController.moneyHistoryPoint[index].qrNumber}"),
                                                    subtitle: Text(formatDate(
                                                            DateTime.parse(
                                                                moneyHistoryController
                                                                    .moneyHistoryPoint[index]
                                                                    .date),
                                                            [
                                                              MM
                                                            ]) +
                                                        "," +
                                                        "${formatDate(DateTime.parse(moneyHistoryController.moneyHistoryPoint[index].date), [
                                                              yyyy
                                                            ])} at " +
                                                        moneyHistoryController
                                                            .moneyHistoryPoint[
                                                                index]
                                                            .time +
                                                        " " +
                                                        formatDate(
                                                            DateTime.parse(
                                                                moneyHistoryController
                                                                    .moneyHistoryPoint[index]
                                                                    .date),
                                                            [am])),
                                                    trailing: Text(
                                                        "\u{20B9} ${moneyHistoryController.moneyHistoryPoint[index].money}"),
                                                  ),
                                                );
                                              },
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "images/no-data.png"),
                                              ],
                                            );
                                    }),
                                    Obx(() {
                                      return redeemMoneyHistoryController
                                              .moneyRedeemHistory.isNotEmpty
                                          ? ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: redeemMoneyHistoryController
                                                  .moneyRedeemHistory.length,
                                              itemBuilder: (context, index) {
                                                print(redeemHistoryController
                                                    .redeemHistoryList.length);
                                                return Card(
                                                  child: ListTile(
                                                    title: Text(
                                                        "Money: \u{20B9}${redeemMoneyHistoryController
                                                            .moneyRedeemHistory[index].moneyRedeemrequest[index].amount}"),
                                                    subtitle: Text(formatDate(
                                                            DateTime.parse(
                                                                redeemMoneyHistoryController
                                                                    .moneyRedeemHistory[index]
                                                                    .moneyRedeemrequest[index]
                                                                    .date),
                                                            [
                                                              MM
                                                            ]) +
                                                        "," +
                                                        "${formatDate(DateTime.parse(redeemMoneyHistoryController
                                                            .moneyRedeemHistory[index]
                                                            .moneyRedeemrequest[index].date), [
                                                              yyyy
                                                            ])} at " +
                                                        redeemMoneyHistoryController
                                                            .moneyRedeemHistory[index]
                                                            .moneyRedeemrequest[index]
                                                            .time +
                                                        " " +
                                                        formatDate(
                                                            DateTime.parse(
                                                                redeemMoneyHistoryController
                                                                    .moneyRedeemHistory[index]
                                                                    .moneyRedeemrequest[index]
                                                                    .date),
                                                            [am])),
                                                    trailing: Text(
                                                        redeemMoneyHistoryController
                                                            .moneyRedeemHistory[index]
                                                            .moneyRedeemrequest[index].status==
                                                                "1"
                                                            ? "Pending"
                                                            : redeemMoneyHistoryController
                                                            .moneyRedeemHistory[index]
                                                            .moneyRedeemrequest[index].status ==
                                                                    "2"
                                                                ? "In Process"
                                                                : redeemMoneyHistoryController
                                                            .moneyRedeemHistory[index]
                                                            .moneyRedeemrequest[index].status==
                                                                        "3"
                                                                    ? "Complete"
                                                                    : redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus ==
                                                                            "4"
                                                                        ? "Cancelled"
                                                                        : "",
                                                        style: TextStyle(
                                                            color:  redeemMoneyHistoryController
                                                                .moneyRedeemHistory[
                                                                            index]
                                                                        .moneyRedeemrequest[
                                                                            index]
                                                                        .status ==
                                                                    "1"
                                                                ? Colors.red
                                                                :  redeemMoneyHistoryController
                                                                .moneyRedeemHistory[
                                                            index]
                                                                .moneyRedeemrequest[
                                                            index]
                                                                .status  ==
                                                                        "2"
                                                                    ? Colors
                                                                        .pink
                                                                    :  redeemMoneyHistoryController
                                                                .moneyRedeemHistory[
                                                            index]
                                                                .moneyRedeemrequest[
                                                            index]
                                                                .status  ==
                                                                            "3"
                                                                        ? Colors
                                                                            .green
                                                                        :  redeemMoneyHistoryController
                                                                .moneyRedeemHistory[
                                                            index]
                                                                .moneyRedeemrequest[
                                                            index]
                                                                .status  ==
                                                                                "4"
                                                                            ? Colors.blue
                                                                            : Colors.white)),
                                                  ),
                                                );
                                              })
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "images/no-data.png"),
                                              ],
                                            );
                                    }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                        /*Obx((){
                         return moneyHistoryController.moneyHistoryPoint.isNotEmpty?ListView.builder(
                           itemCount: moneyHistoryController.moneyHistoryPoint.length,
                           itemBuilder: (context,index){
                             return Card(
                               child:ListTile(
                                 title: Text("Qr No.:${moneyHistoryController.moneyHistoryPoint[index].qrNumber}"),
                                 subtitle:Text(formatDate(DateTime.parse(moneyHistoryController.moneyHistoryPoint[index].date), [MM])+","+"${formatDate(DateTime.parse(moneyHistoryController.moneyHistoryPoint[index].date),[yyyy])} at "+moneyHistoryController.moneyHistoryPoint[index].time+" "+formatDate(DateTime.parse(moneyHistoryController.moneyHistoryPoint[index].date), [am])),
                                 trailing: Text("\u{20B9} ${moneyHistoryController.moneyHistoryPoint[index].money}"),
                               ),
                             );
                           },
                         ):Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Image.asset("images/no-data.png"),
                           ],
                         );
                       }),*/
                        /*ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(

                                //color: Ccolor,
                                child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    indicator: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(30),
                                      color: Ccolor,
                                    ),
                                    controller: historyController,
                                    tabs: [
                                      Tab(child: Text("Scan History")),
                                      Tab(child: Text("Redeem History")),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: TabBarView(
                                  controller: historyController,
                                  children: [
                                    Obx(() {
                                      return scanHistoryController.scanHistory.isNotEmpty
                                          ? ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                          scanHistoryController.scanHistory.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: ListTile(
                                                title: Text(
                                                    "Qr No.:${scanHistoryController.scanHistory[index].qrNumber}"),
                                                subtitle: Text(
                                                    "${formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [
                                                      MM
                                                    ]) + "," + formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [
                                                      yyyy
                                                    ])} at ${scanHistoryController.scanHistory[index].time + " " + formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [am])}  "),
                                                trailing: Text(
                                                    "+${scanHistoryController.scanHistory[index].points} pts"),
                                              ),
                                            );
                                          })
                                          : Center(child: Column(
                                        children: [
                                          Text("No Data Found"),
                                        ],
                                      ));
                                    }),
                                    Obx((){
                                      return redeemHistoryController.redeemHistoryList.isNotEmpty?ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: redeemHistoryController.redeemHistoryList.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: ListTile(
                                                title: Text("Points:${redeemHistoryController.redeemHistoryList[index].redeemrequest[index].points}"),
                                                subtitle: Text(formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date), [MM])+","+"${formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date),[yyyy])} at "+redeemHistoryController.redeemHistoryList[index].redeemrequest[index].time+" "+formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date), [am])),
                                                trailing: Text(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==1?"Pending":redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==2?"In Process":redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==3?"Complete":redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==4?"Cancelled":"",
                                                    style: TextStyle(color:redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==1?Colors.red:redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==2?Colors.pink:redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==3?Colors.green:redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==4?Colors.blue:Colors.white)),
                                              ),
                                            );
                                          }):Center(child: Column(

                                        children: const <Widget>[
                                          Text("No Data Found2"),
                                        ],
                                      ));
                                    }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )*/
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          /* ListView(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    //color: Ccolor,
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Ccolor,
                        ),
                        controller: historyController,
                        tabs: [
                          Tab(child: Text("Scan History")),
                          Tab(child: Text("Redeem History")),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(controller: historyController, children: [
                    Obx(() {
                      return scanHistoryController.scanHistory.isNotEmpty
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  scanHistoryController.scanHistory.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                        "Qr No.:${scanHistoryController.scanHistory[index].qrNumber}"),
                                    subtitle: Text(
                                        "${formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [
                                                  MM
                                                ]) + "," + formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [
                                                  yyyy
                                                ])} at ${scanHistoryController.scanHistory[index].time + " " + formatDate(DateTime.parse(scanHistoryController.scanHistory[index].date), [am])}  "),
                                    trailing: Text(
                                        "+${scanHistoryController.scanHistory[index].points} pts"),
                                  ),
                                );
                              })
                          : Center(child: Column(
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ));
                    }),
                    Obx((){
                      return redeemHistoryController.redeemHistoryList.isNotEmpty?ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: redeemHistoryController.redeemHistoryList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text("Points:${redeemHistoryController.redeemHistoryList[index].redeemrequest[index].points}"),
                                subtitle: Text(formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date), [MM])+","+"${formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date),[yyyy])} at "+redeemHistoryController.redeemHistoryList[index].redeemrequest[index].time+" "+formatDate(DateTime.parse(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].date), [am])),
                                trailing: Text(redeemHistoryController.redeemHistoryList[index].redeemrequest[index].requestStatus==1?"Pending":"",style: TextStyle(color: redeemHistoryController.redeemHistoryList[index].redeemrequest==1?Colors.black:Colors.red),),
                              ),
                            );
                          }):Center(child: Column(

                            children: <Widget>[
                              CircularProgressIndicator(),
                            ],
                          ));
                    }),
                  ]),
                ),
              )
            ],
          ),*/
        ]),
      ),
    );
  }
}
