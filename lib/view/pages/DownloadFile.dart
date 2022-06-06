import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/controller/ColorVisualDownloadController.dart';
import 'package:libertypaints/view/widget/constant.widget.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFilePage extends StatefulWidget {
  final String token;
  const DownloadFilePage({Key? key, required this.token}) : super(key: key);

  @override
  _DownloadFilePageState createState() => _DownloadFilePageState();
}

class _DownloadFilePageState extends State<DownloadFilePage>
    with SingleTickerProviderStateMixin {
  bool permissionGranted = false;
  late AnimationController controller;
  String progress = "";
  ColorVisualDownloadController colorVisualDownloadController =
      Get.put(ColorVisualDownloadController());
  Future getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      getStoragePermission();
      progress.isEmpty;
      progressString = "0";
      controller = AnimationController(
          vsync: this, duration: const Duration(seconds: 1000));
      colorVisualDownloadController.fetchDownloadFile(widget.token);
    });
    super.initState();
  }

  @override
  void dispose() {
    colorVisualDownloadController.downloadFile.clear();
    controller.dispose();
    super.dispose();
  }

  // final imgUrl = "${files}";
  bool downloading = false;
  String progressString = "0%";
  double percentage = 0.0;
  Future<void> downloadFile(String files) async {
    Dio dio = Dio();

    try {
      var dir = await getTemporaryDirectory();
      String savePath = dir.absolute.path + "/myimage.jpg";
      await dio.download(files, savePath, onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        downloading = true;
        progressString = ((rec / total) * 100).toStringAsFixed(0);
        setState(() {
          percentage = double.parse(progressString);
          print(percentage);
        });
      });
      await ImageGallerySaver.saveFile(savePath);
      print("File Path ${savePath}");
      OpenFile.open(savePath);
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progress = "Completed";
    });
    print("Download completed");
  }

  int duration = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
        backgroundColor: Ccolor,
      ),
      body: Obx(() {
        return colorVisualDownloadController.downloadFile.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    progress == "Completed"
                        ? Lottie.asset("images/check-mark-success.json",
                            repeat: false, onLoaded: (composition) {
                            controller.duration = composition.duration;
                            controller.forward();
                          }, controller: controller)
                        : CircularPercentIndicator(
                            radius: 120.0,
                            animation: true,
                            animationDuration: 5,
                            lineWidth: 5,
                            animateFromLastPercent: true,
                            onAnimationEnd: () {},
                            percent: percentage / 100,
                            backgroundColor: Colors.grey,
                            curve: Curves.easeInExpo,
                            center: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Downloading ..."),
                                  Text(
                                    "$progressString%",
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            startAngle: 0,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Ccolor.withOpacity(.5),
                          ),
                    const SizedBox(height: 30),
                    /* downloading?Text(
              "Downloading File: $progressString%",
              style: TextStyle(
                color: Colors.black,
              ),
            ):Text("Downloading File: $progressString"),*/
                    progress == "Completed"
                        ? const Text("File Downloaded Successfully.")
                        : colorVisualDownloadController
                                    .downloadFile[0].status ==
                                "complete"
                            ? FloatingActionButton.extended(
                                backgroundColor: Ccolor,
                                extendedPadding:
                                    const EdgeInsets.symmetric(horizontal: 100),
                                onPressed: () {
                                  String files =
                                      "${baseUrl + colorVisualDownloadController.downloadFile[0].file}";
                                  downloadFile(files);
                                },
                                label: const Text("Download"))
                            : FloatingActionButton.extended(
                                backgroundColor: Colors.grey.shade400,
                                extendedPadding:
                                    EdgeInsets.symmetric(horizontal: 100),
                                onPressed: null,
                                label: Text("Download"),
                              ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
