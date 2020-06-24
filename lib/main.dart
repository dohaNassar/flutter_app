import 'package:flutter/material.dart';
import 'Pages/Setup/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Firebase Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyLoginPage(),
    );
  }
}


