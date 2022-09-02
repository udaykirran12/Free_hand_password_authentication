import 'package:flutter/material.dart';
import 'package:gestures_app/screen/ml%20model/mhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestures_app/screen/checksign.dart';

import 'package:gestures_app/screen/creategesture.dart';

void main() 
{
    runApp(MaterialApp(
    routes:{
    '/':(context) => mhome(),
    '/checksign':(context)=>CheckSign(),
    '/creategesture':(context)=>CreateGesture(),
  },
  )); 
 } 
  // '/sign':(context)=>Sign(),
   // '/home':(context)=>Home(),
   // '/local': (context)=>Local(),
   // '/dsign':(context) => dSign(),
    // '/newgesture': (context) => NewGesture()