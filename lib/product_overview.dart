import 'package:flutter/material.dart';
import 'appDrawer.dart';
import 'carousel.dart';
import 'user_profile.dart';
import 'package:sonime_app/add_blop_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sonime_app/providers/products.dart';
import '../blog_detail.dart';
import 'usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'providers/products.dart';

class ProductOverView extends StatefulWidget {
  const ProductOverView({Key? key}) : super(key: key);

  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  final user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var _isLoading = false;
  var _isInit = true;
  @override
  void initState() {
    // final tits = Provider.of<Products>(context);
    // TODO: implement initState
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
  }
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<Products>(context).getspecificuser(user);
    // final op = Provider.of<Products>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: AppDrawer(),
        body: Container(
          //color: Color(0xFFfce8e8),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFfcdc97),
                // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                // bottomRight: Radius.circular(20))
              ),

              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Welcome to Sonime\'s \nRecipe Blog ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ))
                ],
              ),
              // color: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            ComplicatedImageDemo(),
            SizedBox(
              height: 50,
            ),
            Text('All Recipe',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            ProductItems()
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddBlog.routeName,
                arguments: user!.email);
            // Add your onPressed code here!
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
        ));
  }
}

class ProductItems extends StatefulWidget {
  @override
  State<ProductItems> createState() => _ProductItemsState();
}

class _ProductItemsState extends State<ProductItems> {
  //const Prodigy({ Key? key }) : super(key: key);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var fav = false;
  final Stream<QuerySnapshot> products =
      FirebaseFirestore.instance.collection('products').snapshots();
  final commentRef = FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    final fuckshit = Provider.of<Products>(context).fetchCommentNumber;
    return StreamBuilder<QuerySnapshot>(
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error occured');
          }
          final data = snapshot.requireData;

          //  final comment_no = FirebaseFirestore.instance.collection('products').doc().collection('comments').doc();
          return Expanded(
              child: ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              return Container(
                height: 220,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    //Text('Blog OverView'),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          BlogDetailScreen.routeName,
                          arguments: data.docs[index].id,
                        );
                      },
                      child: 
                          
                          Row(children: [
                            Container(
                                height: 170,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data.docs[index]['image'],
                                        fit: BoxFit.fill,
                                      )),
                                )),
                            SizedBox(width: 10),
                            Container(
                              height: 200,
                              width: 100,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20),
                                    Text('${data.docs[index]['name']}',
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text('by ${data.docs[index]['author']}'),
                                    Text('${data.docs[index]['date']}',style: TextStyle(fontSize: 15),),
                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              //  var isfav = fav;
                                              
                                              FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc('${data.docs[index].id}')
                                                  .update({'fav': !data.docs[index]['fav']});
                                            },
                                            icon: data.docs[index]['fav']
                                                ? Icon(Icons.favorite, color: Colors.red)
                                                : Icon(Icons.favorite_border)),
                                        Icon(Icons.comment_bank_rounded),
                                        Text('${data.docs[index]['commentnumber']}'),
                                        
                                      ],
                                    )
                                  ]),
                            ),
                          ]),
                        
                      
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            },
          ));
        }),
        stream: products);
  }
}
