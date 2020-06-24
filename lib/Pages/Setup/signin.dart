import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Pages/Setup/signup.dart';
import 'file:///C:/Users/jit/AndroidStudioProjects/flutter_app/lib/Pages/ClientPages/homePage.dart';
import 'file:///C:/Users/jit/AndroidStudioProjects/flutter_app/lib/Pages/MershantPages/mershantHomePage.dart';
import 'package:flutterapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLoginPage extends StatefulWidget {
  static int products_count = 0;
  static String user_email = '';
  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  login,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 25, color: darkGrayColor),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your email';
                    }
                  },
                  onSaved: (input) => _email = input.toString().trim(),
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: emailLabel),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Your password needs at least 6 chars';
                    }
                  },
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: passLabel),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 100,
                  height: 45,
                  child: RaisedButton(
                    textColor: whiteColor,
                    color: blueColor,
                    onPressed: signin,
                    child: Text(
                      login,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Do not have an account?',
                        style: TextStyle(fontSize: 10, color: darkGrayColor)),
                    FlatButton(
                      textColor: darkGrayColor,
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MySignupPage()));
                      },
                      child: Text(
                        sign_up,
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Future<void> signin() async{
    final formState = _formKey.currentState;
    String userType = '';
    if(formState.validate()){
      //login to firebase
      formState.save();
      try{
        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        //check if user is client or mershant
        Firestore.instance
            .collection('users')
            .where('email', isEqualTo: _email).limit(1)
            .snapshots()
            .listen((data) =>
            data.documents.forEach((doc){
              userType = doc['type'];
              if(userType == 'client'){
                MyLoginPage.user_email = doc['email'];
                MyLoginPage.products_count = doc['product_count'];
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(user: user)));
              }else if(userType == 'mershant'){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MershantPage(user: user)));
              }
            }));
      }catch(e){
        print(e.message);
      }
    }
  }
}
