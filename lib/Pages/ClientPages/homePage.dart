import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/Pages/ClientPages/childrenCategoryPage.dart';
import 'package:flutterapp/Pages/ClientPages/clientSubmittedProducts.dart';
import 'package:flutterapp/Pages/ClientPages/menCategoryPage.dart';
import 'package:flutterapp/Pages/ClientPages/myOrdersPage.dart';
import 'package:flutterapp/Pages/ClientPages/womenCategoryPage.dart';
import 'package:flutterapp/Pages/Setup/signin.dart';

import '../../constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //widget.user.email


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Categories'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart),

            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyOrderPage()));
            },
          ),
        ],),


        body: Container(
          margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          RaisedButton(
            textColor: whiteColor,
            color: lightBlueColor,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClientSubmittedProducts()));
            },
            child: Text(
              'Submitted Orders',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 30,
          ),

          Container(
            width: 130,
            height: 60,
            child: RaisedButton(
              textColor: whiteColor,
              color: blueColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WomenPage()));
              },
              child: Text(
                women,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 130,
            height: 60,
            child: RaisedButton(
              textColor: whiteColor,
              color: blueColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MenPage()));
              },
              child: Text(
                men,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 130,
            height: 60,
            child: RaisedButton(
              textColor: whiteColor,
              color: blueColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChildrenPage()));
              },
              child: Text(
                children,
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
