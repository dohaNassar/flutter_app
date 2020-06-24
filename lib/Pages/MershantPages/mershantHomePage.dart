import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Pages/MershantPages/addProductPage.dart';
import 'package:flutterapp/Pages/MershantPages/mershantSubmmitProducts.dart';

import '../../constants.dart';

class MershantPage extends StatefulWidget {
  const MershantPage({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _MershantPageState createState() => _MershantPageState();
}

class _MershantPageState extends State<MershantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            width: 130,
            height: 60,
            child: RaisedButton(
              textColor: whiteColor,
              color: blueColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MershantSubmmitProducts()));
              },
              child: Text(
                'Orders',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 130,
            height: 60,
            child: RaisedButton(
              textColor: whiteColor,
              color: blueColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProductPage()));
              },
              child: Text(
                'Add Product',
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
