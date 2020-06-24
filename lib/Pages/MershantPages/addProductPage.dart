import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  File picture;
  String _productName, _productCategory, _productImg = "";
  int _productPrice;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File _imageFile;

  void pickImage() async{
    picture = await ImagePicker.pickImage(source: ImageSource.gallery);

    this.setState(() {
      _imageFile = picture;
    });
  }

  Future uploadFile() async {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(id);
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.onComplete;

    String url = await storageReference.getDownloadURL();
    setState(() {
      _productImg = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Product'),),
      body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please write product name';
                    }
                  },
                  onSaved: (input) => _productName = input.toString().trim(),
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: 'Product Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please write product Price';
                    }
                  },
                  onSaved: (input) => _productPrice = int.parse(input),
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: 'Product Price'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please write product Category';
                    } else if(input.toLowerCase() != 'women' && input.toLowerCase() != 'men' && input.toLowerCase() != 'children'){
                      return 'You Can Just Enter '+women+", "+men+", "+children+" as a category";
                    }
                  },
                  onSaved: (input) => _productCategory = input,
                  decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: blueColor)),
                      labelText: 'Product Category'),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 100,
                  height: 45,
                  child: RaisedButton(
                    textColor: whiteColor,
                    color: blueColor,
                    onPressed: pickImage,
                    child: Text(
                      'Pick Image',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
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
                    onPressed: (){
                      uploadFile();
                      addProduct();
                    },
                    child: Text(
                      'Add Product',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> addProduct() async{
    await uploadFile();
    final formState = _formKey.currentState;
    if(formState.validate()){
      //login to firebase
      formState.save();
      try{
        //add to product collection
        Firestore.instance.collection('products').document()
            .setData({ 'category': _productCategory,
          'img': _productImg/*'https://firebasestorage.googleapis.com/v0/b/myflutterapp-a58aa.appspot.com/o/dress.jpg?alt=media&token=9f09a954-6a0d-4dbd-b1d4-37f8b853ecfa'*/,
          'name': _productName, 'price': _productPrice});
      }catch(e){
        print(e.message);
      }
    }
  }

}
