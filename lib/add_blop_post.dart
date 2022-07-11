import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
//import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sonime_app/providers/products.dart';

class AddBlog extends StatefulWidget {
  // const AddBlog({ Key? key }) : super(key: key);

  final name;
  static const routeName = 'add-Blog';
  AddBlog({this.name});
  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  // final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();
  final user = FirebaseAuth.instance.currentUser;
  Future spec() async {
    final userss = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.forEach((element) => element['email']));

    return userss;
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref('files').child(path);
    ref.putFile(file);
    // final snapshot = await uploadTask?.whenComplete(() => {});
    final urlDownload = await ref.getDownloadURL();
    //await snapshot?.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }

  Future submit(name) async {
    if (_form.currentState!.validate() && pickedFile != null) {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref('files').child(path);
      ref.putFile(file);
      // final snapshot = await uploadTask?.whenComplete(() => {});
      final month = DateTime.now().month.toString();
      final day = DateTime.now().day.toString();
      final year = DateTime.now().year.toString();
      final urlDownload = await ref.getDownloadURL();
      //await snapshot?.ref.getDownloadURL();
      print('Download Link: $urlDownload');
      //imgList.add(_imageUrlController.text.trim());
      Products.add({
        'author': name,
        'name': _titleController.text.trim(),
        'id': DateTime.now().millisecond,
        'prep': _prepController.text,
        'image': urlDownload, //_imageUrlController.text.trim(),
        'commentnumber': 0,
        'fav': false,
        'date': '${day}-${month}-${year}'
      }).then((_) {
        // imgList.add(_imageUrlController.text);
        Navigator.pop(context);
      });
      //imgList.add(_imageUrlController.text);
    } else if (pickedFile == null) {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: const Text('No Image Found'),
                  content: const Text('Please enter an Image'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'okay'),
                      child: const Text('Cancel'),
                    ),
                  ]));
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  final Products = FirebaseFirestore.instance.collection('products');

  final _titleController = TextEditingController();
  final _prepController = TextEditingController();

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> users =
        FirebaseFirestore.instance.collection('users').snapshots();
    final name = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(backgroundColor: Colors.red),
        body: StreamBuilder(
          stream: users,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('please wait');
            } else if (snapshot.hasError) {
              return Text('Error occured');
            }
            final data = snapshot.requireData.docs
                .firstWhere((element) => element['email'] == name);
            return Form(
                key: _form,
                child: ListView(children: <Widget>[
                  SizedBox(height: 10),
                  
                  Center(
                    child: Text(
                      'Create a Blog Post',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (pickedFile != null) 
                          Container(
                            width: 200,
                            height: 150,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                     borderRadius: BorderRadius.circular(10),
                                    // color: Colors.blue[100],
                                    child: Image.file(
                                      File(pickedFile!.path!),
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ))),
                          ),
                        IconButton(
                          icon: Icon(Icons.camera_alt_rounded),
                          onPressed: () {
                            print(data['name']);
                            selectFile();
                          },
                        
                          
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Recipe Name'),
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      } else if (value.length >= 25) {
                        return 'Please the length of title should not be over 30 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _titleController.text = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Preparation'),
                    textInputAction: TextInputAction.next,
                    controller: _prepController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill this field.';
                      }
                      if (value.length < 10) {
                        return 'Should be at least 10 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _prepController.text = value!;
                    },
                  ),
                  
                 SizedBox(height: 100),
                   ButtonTheme(
                        minWidth: 50,
                        height: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            submit(data['name']);
                          },
                          child: Text('Submit Blog Post'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              //    padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 30))),
                        )),
                  
                ]));
          },
        ));
  }
}
