import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Pages/Setup/signin.dart';

import '../../constants.dart';

class WomenPage extends StatefulWidget {

  @override
  _WomenPageState createState() => _WomenPageState();
}

class _WomenPageState extends State<WomenPage> {
  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      return Container( margin:EdgeInsets.all(20), child: Row(children: <Widget>[
        Image.network(document['img'], width: 100, height: 150,),
        Container(margin: EdgeInsets.all(25),
            child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: <Widget>[

              Text(document['name'], style: TextStyle(fontSize: 15)),
              SizedBox(height: 5,),
              Text(document['price'].toString()+" \$", style: TextStyle(fontSize: 10)),
              SizedBox(height: 10,),
              RaisedButton(
                textColor: whiteColor,
                color: blueColor,
                onPressed: (){
                  //update user count product
                  //add to buyed collection
                  //increase count by one

                  setState(() {
                    //increase count by one
                    MyLoginPage.products_count += 1;

                  });

                  //update user count product
                  Firestore.instance
                      .collection('users')
                      .where("email", isEqualTo: MyLoginPage.user_email)
                      .snapshots()
                      .listen((data) =>
                      data.documents.forEach((doc){
                        try {
                          Firestore.instance
                              .collection('users')
                              .document(doc.documentID)
                              .updateData({'product_count': MyLoginPage.products_count});
                        } catch (e) {
                          print(e.toString());
                        }
                      }));

                  //add to buyed collection
                  Firestore.instance.collection('buyedProducts').document()
                      .setData({ 'category': document['category'], 'count': 1,
                    'img': document['img'], 'price': document['price'],
                    'product_name': document['name'], 'user_email': MyLoginPage.user_email,
                    'client_submitted': false, 'mershant_submitted': false });


                },
                child: Text(
                  'Buy',
                  style: TextStyle(fontSize: 10),
                ),
            ),

        ],),),



      ],),);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Women Category'),
        leading: Text(MyLoginPage.products_count.toString(), style: TextStyle(fontSize: 25),),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('products')
              .where('category', isEqualTo: 'women')
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
      ),

    );
  }
}
