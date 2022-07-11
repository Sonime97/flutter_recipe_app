import 'dart:ui';

import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Comments extends StatefulWidget {
 // const Comments({ Key? key }) : super(key: key);
 String str;
 int id;
 Comments({required this.id,required this.str});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context)  { 
   var t = '8ooLDoL1c2uAXAo3AHmY';
   final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
   .collection('products')
   .doc(widget.str).collection('comments').snapshots();

   return StreamBuilder(
    stream: posts,
    builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting) {
            return Text('please wait');
          }
          else if(snapshot.hasError) {
            return Text('Error occured');
          }
          print(snapshot.requireData.docs.length);
          FirebaseFirestore.instance.collection('products').doc(widget.str)
          .update({'commentnumber': snapshot.requireData.docs.length});
        // final username = FirebaseFirestore.instance.collection()
          final data = snapshot.requireData.docs;
          return Container(

            child: Column(
              children: [
                Text('Comments(${snapshot.requireData.docs.length})',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Container(
                 height: 200,           
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx,index) => 
                  Column(
                    children: [
                      Container(
                        height: 100,
                        child: Card(
                        color: Colors.white,
                        child: 
                        ListTile(
                          leading: Text('${data[index]['name']} : ',style: TextStyle(fontWeight: FontWeight.bold),),
                          title: Text('${data[index]['comment']}'),
                          ),
                     
                          
                           
                        ),
                      ),
                     
                    ],
                  ),
                //  ,Text(' user: ${data[index]['name']} '),
               //   Text('${data[index]['comment']} ')
                  
                  
                  
                   
                  ),
              )],
            ),
          );
      
  });   
  }
}
