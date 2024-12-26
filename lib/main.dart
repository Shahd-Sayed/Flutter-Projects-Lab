import 'package:flutter/material.dart';
import 'package:flutter_application_8/Financial/S_welcome.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: EventListScreen(),  //Alhussien
      // home: ProductListScreen(),  //kareem
      // home: Welcome(),  //lana
      // home: AttendanceScreen(),  //Omnia
      home: SWelcomeScreen(),  //shahd
    );
  }
}
