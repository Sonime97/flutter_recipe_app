import 'package:firebase_auth/firebase_auth.dart';
import 'comments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'providers/products.dart';

class BlogDetailScreen extends StatefulWidget {
  static const routeName = 'blog-detailScreen';
  //const BlogDetailScreen({ Key? key }) : super(key: key);
  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
   
  final Stream<QuerySnapshot> products =
      FirebaseFirestore.instance.collection('products').snapshots();
  var commentNo = 0;
  @override
  Widget build(BuildContext context) {
    final _commentController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final ProductId = ModalRoute.of(context)!.settings.arguments;
    final CommentCountRef =
        FirebaseFirestore.instance.collection('products').doc('${ProductId}');
    final CommentRef = FirebaseFirestore.instance
        .collection('products')
        .doc("${ProductId}")
        .collection('comments');
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFfcdc97),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                        isDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Center(
                              child: InkWell(
                                child: Card(
                                    child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        onSaved: (value) {
                                          _commentController.text =
                                              value.toString();
                                        },
                                        controller: _commentController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 3,
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          } else if (value.length < 10) {
                                            return 'Text must be greater than 10';
                                          }
                                          return null;
                                        },
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Validate returns true if the form is valid, or false otherwise.
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // commentNo++;
                                                // CommentCountRef.add();
                                                CommentRef.add({
                                                  "name": FirebaseAuth.instance
                                                      .currentUser!.email,
                                                  'comment':
                                                      _commentController.text
                                                },
                                                
                                                );
                                                // print(ProductId);
                                                // If the form is valid, display a snackbar. In the real world,
                                                // you'd often call a server or save the information in a database.
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Comment Added')),
                                                );
                                                _commentController.clear();
                                              }
                                            },
                                            child: const Text('Submit'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.add_comment)),
              label: ' Add comments',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.home),
              ),
              label: 'Home',
            ),
          ],
          selectedItemColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          builder:
              ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('please wait');
            } else if (snapshot.hasError) {
              return Text('Error occured');
            }
            //   print(ProductId);

            final data = snapshot.requireData.docs
                .firstWhere((element) => element.id == ProductId);
            // print(data['id']);
            // print(ProductId);
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                //  color: Color(0xFFfce8e8),
                child: Container(
                  height: 200,
                  child: Column(children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            data['image'],
                            fit: BoxFit.fill,
                          ),
                        )),
                    SizedBox(height: 40),
                    Container(
                        color: Colors.white,
                        child: Column(children: [
                          Text(
                            data['name'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 300,
                            child: ListView(children: [
                              Center(child: Text('Process', style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                              Center(
                                child: Text(
                                  data['prep'],
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Comments(
                                id: data['id'],
                                str: data.id,
                              ),
                            ]),
                          )
                        ])),
                  ]),
                ),
              ),
            );
          }),
          stream: products,
        ));
  }
}
