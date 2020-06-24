import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MershantSubmmitProducts extends StatefulWidget {
  @override
  _MershantSubmmitProductsState createState() => _MershantSubmmitProductsState();
}

class _MershantSubmmitProductsState extends State<MershantSubmmitProducts> {

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      return Card( elevation:3.0, margin:EdgeInsets.all(20), child: Row(children: <Widget>[
        Container(margin: EdgeInsets.all(25),
          child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: <Widget>[

            Text(document['product_name'], style: TextStyle(fontSize: 20)),
            SizedBox(height: 5,),
            Text(document['price'].toString()+" \$", style: TextStyle(fontSize: 15)),
            SizedBox(height: 5,),
            Text(document['count'].toString(), style: TextStyle(fontSize: 15)),
            SizedBox(height: 5,),
            Text(document['user_email'].toString(), style: TextStyle(fontSize: 15)),
            SizedBox(height: 10,),
            RaisedButton(
              textColor: whiteColor,
              color: blueColor,
              onPressed: (){
                //update mershant_submitted
                try {
                  Firestore.instance
                      .collection('buyedProducts')
                      .document(document.documentID)
                      .updateData({'mershant_submitted': true});
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 15),
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
        title: Text('Orders'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('buyedProducts')
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
      ),

    );
  }
}
