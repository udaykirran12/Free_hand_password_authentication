import 'package:flutter/material.dart';
import 'package:gestures_app/screen/checksign.dart';
import 'package:gestures_app/screen/creategesture.dart';

class mhome extends StatefulWidget {
  mhome({Key? key}) : super(key: key);

  @override
  State<mhome> createState() => _mhomeState();
}

class _mhomeState extends State<mhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Gesture Verification',
        style: TextStyle(fontFamily: 'RobotoMono'),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 250),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>CreateGesture()));
                  }, child: Text('New Gesture')),
              ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckSign()));
                   // Navigator.pushNamed(context, '/checksign');
                    
                  }, child: Text('Verify Gesture'))
            ],
          ),
        ),
      ),
    );
  }
}