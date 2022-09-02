import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestures_app/screen/ml%20model/mhome.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
class CreateGesture extends StatefulWidget {
  CreateGesture({Key? key}) : super(key: key);
  @override
  State<CreateGesture> createState() => _CreateGestureState();
}
class _CreateGestureState extends State<CreateGesture> {
  final screenshotController = ScreenshotController();
  int c=1;
  bool b=false;  
  List<Offset?> points=[];
  Uint8List? imagepath; 
  dynamic createimageFile;
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
          child: Text("Create your gesture",style: TextStyle(fontSize: 26,color: Colors.black,),),
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
              await createtakeScreenshot();
              setState((){
                    b=false;
                    createimageFile = createimageFile;
                    points.clear();
                  });
              Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      mhome()),
             (Route<dynamic> route) => false
              );
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
   createtakeScreenshot()async
  {
    print("screenshot taken");
    createimageFile = await screenshotController.capture();
    //print(createimageFile);
    await saveFile(createimageFile);
  }
   saveFile(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    // print("base64Image is : ");
    // print(base64Image);
    prefs.setString("created_image", base64Image);
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
    return true;
  }
}