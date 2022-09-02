import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestures_app/screen/ml%20model/mhome.dart';

import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
class CheckSign extends StatefulWidget {
  CheckSign({Key? key}) : super(key: key);
  @override
  State<CheckSign> createState() => _CheckSignState();
}
class _CheckSignState extends State<CheckSign> {
  final screenshotController = ScreenshotController();
  String d= "Draw";
  int c=1;
  bool b=false;
  List<Offset?> points=[];
  Uint8List? imagepath; 
  dynamic createimageFile, drawimageFile,drawnImage;
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
          margin: EdgeInsets.only(top:size*0.15),
          child: Text("$d gesture",style: TextStyle(fontSize: 26,color: Colors.black,),),
          color: Colors.white,
          ),
          Screenshot(
            controller: screenshotController,
            child: Container(
              margin: EdgeInsets.only(top:10),
              height:500 ,
              width: 400,
              decoration: BoxDecoration(
               ///color: Colors.white,
                 border: Border.all(
                  color: Colors.black,width: 0.1
                 ),
                 boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 0.8,
                  blurRadius: 0.5,
                 ),]
              ),
              child: GestureDetector(
                onPanDown: (details){
                        this.setState(() {
                          points.add(details.localPosition);
                          b=true;
                        });
                },
                onPanUpdate: (details){
                      this.setState(() {
                        points.add(details.localPosition);
                        b=true;
                      });
                },
                onPanEnd: (details){
                          this.setState(() {
                            points.add(null);
                          });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CustomPaint(
                    painter: MyCustomPainter(points: points),
                  ),
                ),
              ),  
                  ),
          ),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed:b?(){
            points.clear();
            setState(() {
              b=false;
            });
          }:null, 
          child:Text("Clear",style: TextStyle(fontSize: 20),),
          style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: StadiumBorder()
          )
         ),
          ElevatedButton(
              onPressed:b?()async{
                 drawnImage = await drawtakeScreenshot();
                 createimageFile = await getImage();
                 var d = await sendImagestoflask(drawnImage,createimageFile);
                  var decoded = jsonDecode(d);
                  //print(decoded['output']);
                  //  drawnImage = await drawtakeScreenshot();
                  //  createimageFile = await getImage();
                  // //  print("createdImage is :");
                  // //  print(createimageFile);
                  //  var data = await sendImageonetoflask(drawnImage,createimageFile);
                  //  var decoded1 = jsonDecode(data);
                  //  print("DECODED DATA IS :");
                  //  print(decoded1['output']);
                  //  var data2 = await sendImagetwoflask(createimageFile);
                  //  //print("The data is $data");
                  //  var decoded2 = jsonDecode(data2);
                  // // print(decoded2['output']);
                  setState(() {
                            b=false;
                            drawnImage = drawnImage;
                            createimageFile = createimageFile;
                          });
              
                if(decoded['output']=="YES")
                   {
                    // Navigator.pushNamed(context, '/newgesture');
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context)=> mhome()
                    // ));
                  await   showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Verification'),
                            content: const Text('Gesture matched'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/checksign'),
                                child: const Text('Try again'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                      );
                    //    Navigator.push(context, MaterialPageRoute(
                    //   builder: (context)=> mhome()
                    // ));
                   }
                else
                {
                //  setState(() {
                //    d= "Redraw";
                //  });
                await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Verification'),
                            content: const Text('Gesture not matched'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/checksign'),
                                child: const Text('Try Again'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                      );
                    //    Navigator.push(context, MaterialPageRoute(
                    //   builder: (context)=> CheckSign()
                    // )); 
                }
             }:null, 
             child: Text("Done",style: TextStyle(fontSize: 20),),
             style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 254, 3, 3),
              shape: StadiumBorder()
            ),
          ),],
        ),
          ]
        ),
        ),    
  );
  }
  sendImagestoflask(String drawnImage, String createimageFile)async
  {  //http://127.0.0.1:5000
    String url = "http://10.0.2.2:5000/both";
    http.Response response = await http.post(Uri.parse(url),
     body: jsonEncode({
      "image1": drawnImage,
      "image2":createimageFile,
      "output":"failure"
     })
    );
    return response.body;
  }
  sendImageonetoflask(String drawnImage,String createimageFile)async
  {
     //print("went to api");
     String  url = "http://10.0.2.2:5000/imageone?image1="+drawnImage.toString()+"&image2="+createimageFile;
     //String url = "http://10.0.2.2:5000/imageone";
     http.Response response = await http.get(Uri.parse(url));
     return response.body;
  }
  sendImagetwoflask(String createimageFile)async
  {
    String url2 = "http://10.0.2.2:5000/imagetwo?image2="+createimageFile.toString();
    //String url2 = "http://10.0.2.2:5000/imagetwo";
    http.Response response2 = await http.get(Uri.parse(url2));
    return response2.body;
  }
   drawtakeScreenshot()async{
    drawimageFile = await screenshotController.capture();
    drawnImage = base64Encode(drawimageFile);
    return drawnImage;
  }
  getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? base = prefs.getString("created_image");
    // print("get image datatype is ${base.runtimeType}");
    // print("get image is:");
    // print(base);
    return base;
    // Image got_image = Image.memory(base64.decode('base'));
    // // print("data type of get image is ${got_image.runtimeType}");
    // // print("IMAGE IS : $got_image");
    // return got_image;
  }
}
class MyCustomPainter extends CustomPainter
{

  List<Offset?> points;
  MyCustomPainter({required this.points});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint background=Paint()..color = Colors.white;
    Rect rect =Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    Paint paint=Paint()..color=Colors.black;
    paint.strokeWidth=2.0;
    paint.isAntiAlias=true;
    paint.strokeCap = StrokeCap.round;
    for(int i=0;i<points.length-1;i++)
    {
      if((points[i]!=null)&& (points[i+1]!=null))
      {
          canvas.drawLine(points[i]!, points[i+1]!, paint);
           
      }
      else if(points[i]!=null&&points[i+1]==null)
      {
          canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }

    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    //throw UnimplementedError();
    return true;
  }
}
