import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Pages/Setup/signin.dart';

import '../../constants.dart';

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();



}

class _MyOrderPageState extends State<MyOrderPage> {

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      int product_count = document['count'];
      return Container(
        margin: EdgeInsets.all(2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                try {
                  Firestore.instance
                      .collection('buyedProducts')
                      .document(document.documentID)
                      .delete();
                    MyLoginPage.products_count -= 1;

                } catch (e) {
                  print(e.toString());
                }

              },
            ),
            Image.network(
              document['img'],
              width: 100,
              height: 150,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Increase product by 1',
                  onPressed: () {
                    product_count += 1;
                    //update user count product
                    try {
                      Firestore.instance
                          .collection('buyedProducts')
                          .document(document.documentID)
                          .updateData({'count': product_count});
                      setState(() {});
                    } catch (e) {
                      print(e.toString());
                    }


                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text(product_count.toString()),
                SizedBox(
                  height: 5,
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  tooltip: 'Decrease product by 1',
                  onPressed: () {
                    if (product_count != 1) {
                      product_count -= 1;
                      //update user count product
                      try {
                        Firestore.instance
                            .collection('buyedProducts')
                            .document(document.documentID)
                            .updateData({'count': product_count});
                        setState(() {});
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(document['product_name'],
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(document['price'].toString() + " \$",
                      style: TextStyle(fontSize: 10)),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    textColor: whiteColor,
                    color: blueColor,
                    onPressed: () {

                      try {
                        Firestore.instance
                            .collection('buyedProducts')
                            .document(document.documentID)
                            .updateData({'client_submitted': true});

                          MyLoginPage.products_count-=1;
                          setState(() {

                          });
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text(
                      'Submmit Order',
                      style: TextStyle(fontSize: 10),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('users')
        .where('email', isEqualTo: MyLoginPage.user_email)
        .snapshots().listen((data) => data.documents.forEach((doc){
      Firestore.instance
          .collection('users')
          .document(doc.documentID)
          .updateData({'product_count': MyLoginPage.products_count});
    }));
    return Scaffold(
        body: StreamBuilder(
              stream: Firestore.instance
                  .collection('buyedProducts')
                  .where('user_email', isEqualTo: MyLoginPage.user_email)
                  .where('client_submitted', isEqualTo: false)
                  .where('mershant_submitted', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: makeListWidget(snapshot),
                    );
                }
              },
            ),


       );
  }

}
