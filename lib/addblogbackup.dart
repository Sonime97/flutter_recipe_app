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
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();
  final user = FirebaseAuth.instance.currentUser;
  Future spec() async {
    final userss = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.forEach((element) =>
            element['email']
            
            ));

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

  Future submit() async {
    if (_form.currentState!.validate() && pickedFile != null) {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref('files').child(path);
      ref.putFile(file);
      // final snapshot = await uploadTask?.whenComplete(() => {});
      final urlDownload = await ref.getDownloadURL();
      //await snapshot?.ref.getDownloadURL();
      print('Download Link: $urlDownload');
      //imgList.add(_imageUrlController.text.trim());
      Products.add({
        'author': user,
        'name': _titleController.text.trim(),
        'id': DateTime.now().millisecond,
        'prep': _prepController.text,
        'image': urlDownload, //_imageUrlController.text.trim(),
        'commentnumber': 0
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
    final name = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Color(0xFFfce8e8),
      appBar: AppBar(backgroundColor: Colors.red),
      body: 
      
      Form(
          key: _form,
          child: ListView(children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Create a Blog Post',
              style: TextStyle(fontSize: 25),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'BLOG TITLE'),
              textInputAction: TextInputAction.next,
              controller: _titleController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value';
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
            SizedBox(height: 20),
            Center(
                child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pickedFile != null)
                    Expanded(
                        child: Container(
                            width: 200,
                            height: 150,
                            // color: Colors.blue[100],
                            child: Image.file(
                              File(pickedFile!.path!),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ))),
                ],
              ),
            )),
            ButtonTheme(
              minWidth: 50,
              height: 20,
              child: ElevatedButton(
                onPressed: () {
                  spec();
                  selectFile();
                },
                child: Text(' Select an Image +'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    //    padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 30))),
              ),
            ),
            ButtonTheme(
                minWidth: 50,
                height: 20,
                child: ElevatedButton(
                  onPressed: () {
                    submit();
                  },
                  child: Text('Submit Blog Post'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      //    padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 30))),
                ))
          ])),
    );
  }
}

class hu extends StatelessWidget {
  const hu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var change = true;
    final _imageUrlController = TextEditingController();
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(
          top: 8,
          right: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        child: change
            ? Text('ENTER AN IMAGE')
            : FittedBox(
                child: Image.network(
                  _imageUrlController.text,
                  fit: BoxFit.cover,
                ),
              ),
      ),
      Expanded(
          child: TextFormField(
              onChanged: (value) {
                if (_imageUrlController.text.isNotEmpty) {
                  _imageUrlController.text = value;
                  //  setState(() {
                  //    change = !change;
                  //  });
                }
              },
              decoration: InputDecoration(labelText: 'Image URL'),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              controller: _imageUrlController,
              //  focusNode: _imageUrlFocusNode,

              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an image URL.';
                }
                if (!value.startsWith('http') && !value.startsWith('https')) {
                  return 'Please enter a valid URL.';
                }
                if (!value.endsWith('.png') &&
                    !value.endsWith('.jpg') &&
                    !value.endsWith('.jpeg')) {
                  return 'Please enter a valid image URL.';
                }
                return null;
              },
              onSaved: (value) {
                _imageUrlController.text = value!;
              }))
    ]);
  }
}
