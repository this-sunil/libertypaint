import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libertypaints/config.dart';
import 'package:libertypaints/view/notification/NotificationDetails.dart';
import 'package:libertypaints/view/pages/DownloadFile.dart';
import 'package:libertypaints/view/widget/NotificationCounters.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../widget/constant.widget.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
class ColorVisualization extends StatefulWidget {
  final String token;
  const ColorVisualization({Key? key,required this.token}) : super(key: key);

  @override
  State<ColorVisualization> createState() => _ColorVisualizationState();
}

class _ColorVisualizationState extends State<ColorVisualization> {
  final List<XFile> _image = [];
  bool uploading = false;
  bool spinner=false;
  final picker = ImagePicker();

  Future uploadImage() async{
    setState(() {
      spinner=true;
    });

    int length;
    var multipartFiles;
    var request = http.MultipartRequest(
        "POST", Uri.parse("${baseUrl}api/visualizerRequestApi"));
    request.headers.addAll({
      "Accept":"application/json",
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'multipart/form-data'
    });
    length = _image.length;
    print("length $length");
    if(_image.isNotEmpty){
     for(int i=0;i<_image.length;i++) {

       request.fields["images[]"]=_image[i].path;
       multipartFiles =  http.MultipartFile.fromPath("images[]", request.fields["images[]"]=_image[i].path,
           filename: basename(_image[i].path));
       print(multipartFiles);

     }
      request.files.add(await multipartFiles);
      var res = await request.send();
      print("Response +${res.statusCode}");
      if (res.statusCode == 200) {
        http.Response response=await http.Response.fromStream(res);
        Map<String,dynamic> result=jsonDecode(response.body);
        Fluttertoast.showToast(msg: "${result["message"]}");

        print("Response Multiple images:${res.statusCode}");

        setState(() {
          spinner = false;
          _image.clear();
        });
      } else {
        Fluttertoast.showToast(msg:"failed ${res.statusCode}");
        spinner = false;
      }
    }

  }

  chooseImage() async {
    List<XFile>? pickedFile = await picker.pickMultiImage();
    setState(() {
      _image.addAll(pickedFile!);
      print(_image.first.path);
    });
    if (pickedFile!.isEmpty) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
   print("images retrieve ${response.files?.first.path}");
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      setState(() {
        _image.addAll(response.files!);
      });
    } else {
      print(response.files);
    }
  }
  @override
  void initState() {
    retrieveLostData();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final counter =
    Provider.of<NotificationCounters>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Ccolor,
        title: const Text(
          "Color Visualization",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
            if(_image.isNotEmpty)IconButton(onPressed: (){
              !uploading ? chooseImage() : null;
    }, icon: const Icon(Icons.add)),
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DownloadFilePage(token: widget.token)));
        }, icon: Icon(Icons.cloud_download)),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          heroTag: "choose image",
          extendedPadding: EdgeInsets.symmetric(horizontal: 100),
          backgroundColor: Ccolor,
          onPressed: (){
           setState(() {
            if(_image.isNotEmpty){
              uploadImage();
            }
            else{
              Fluttertoast.showToast(msg: "Please Select an image");
            }
           });
          },

          label: const Text("Upload Image"),
        ),
      ),

      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: _image.isEmpty?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DottedBorder(

                  radius:const Radius.circular(5.0),
                  dashPattern: [5,4],
                  borderType: BorderType.RRect,
                  child: Stack(

                      children: [
                        Image.asset("images/upload_image.jpg"),
                        Positioned(
                            top: 50,
                            left: 50,
                            child: FloatingActionButton(
                              heroTag: "Add image",
                              mini: true,
                              onPressed: () {
                                setState(() {
                                  !uploading ? chooseImage() : null;
                                });
                              },child: Icon(Icons.add),)),

                      ])),
             /* Center(
                child: ElevatedButton(
                  style: ButtonStyle(

                    backgroundColor: MaterialStateProperty.all(Ccolor),
                  textStyle:MaterialStateProperty.all( const TextStyle(color: Colors.white)),
                  ),
                  onPressed: (){
                    !uploading ? chooseImage() : null;
                  },child: const Text("Select Image")),
              ),*/
            ],
          ),
        ):StaggeredGridView.builder(
            itemCount: _image.length,
            gridDelegate:  SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                staggeredTileCount: _image.length,
                staggeredTileBuilder: (index){
                  return StaggeredTile.count(1, index.isEven?2:1);
                }),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  showImage(_image[index].path,context);
                },
                child: Hero(
                  tag: _image[index].path,
                  child: Card(
                    child: Image.file(File(_image[index].path),
                        fit: BoxFit.cover,
                        ),
                  ),
                ),
              );
            }),
      ),
    );
  }
  showImage(String image,BuildContext context){
    return showDialog(context: context, builder: (context){
      return Hero(
        tag: image,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: InteractiveViewer(
            maxScale: 5.0,
            child: Image.file(File(image),fit: BoxFit.contain),
          ),
        ),
      );
    });
  }
}
