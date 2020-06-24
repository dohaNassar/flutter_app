import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Pages/Setup/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';

class MySignupPage extends StatefulWidget {
  @override
  _MySignupPageState createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  String _email, _password, _name, _type;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  sign_up,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 25, color: darkGrayColor),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your name';
                    }
                  },
                  onSaved: (input) => _name = input.toString().trim(),
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: nameLabel),
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
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please write your type';
                    }else if(input.toLowerCase() != 'client' && input.toLowerCase() != 'mershant'){
                      return 'Please write your type correct';
                    }

                  },
                  onSaved: (input) => _type = input.toString().trim().toLowerCase(),
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: typeLabel),
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
                    onPressed: signup,
                    child: Text(
                      sign_up,
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
                    Text('Already have an account?',
                        style: TextStyle(fontSize: 10, color: darkGrayColor)),
                    FlatButton(
                      textColor: darkGrayColor,
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
                      },
                      child: Text(
                        signin,
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
  Future<void> signup() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      //login to firebase
      formState.save();
      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        //save user in users collection
        Firestore.instance.collection('users').document()
            .setData({ 'name': _name, 'email': _email, 'type': _type, 'product_count': 0 });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
      }catch(e){
        print(e.message);
      }
    }
  }


}
