import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Pages/Setup/signin.dart';

import '../../constants.dart';

class ClientSubmittedProducts extends StatefulWidget {
  @override
  _ClientSubmittedProductsState createState() => _ClientSubmittedProductsState();
}

class _ClientSubmittedProductsState extends State<ClientSubmittedProducts> {

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      return Container( margin:EdgeInsets.all(20), child: Row(children: <Widget>[
        Image.network(document['img'], width: 100, height: 150,),
        Container(margin: EdgeInsets.all(25),
          child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: <Widget>[

            Text(document['product_name'], style: TextStyle(fontSize: 15)),
            SizedBox(height: 5,),
            Text(document['price'].toString()+" \$", style: TextStyle(fontSize: 10)),
            SizedBox(height: 5,),
            Text("Mershant submit: "+document['mershant_submitted'].toString(), style: TextStyle(fontSize: 10)),
            SizedBox(height: 10,),

          ],),),

      ],),);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Orders'),
        leading: Text(MyLoginPage.products_count.toString(), style: TextStyle(fontSize: 25),),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('buyedProducts')
              .where('user_email', isEqualTo: MyLoginPage.user_email)
              .where('client_submitted', isEqualTo: true)
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
