import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  // const ProfilePage({ Key? key }) : super(key: key);
  String username;
  ProfilePage({required this.username});
  @override
  Widget build(BuildContext context) {
    final sk = FirebaseAuth.instance.currentUser;
    final year = FirebaseAuth.instance.currentUser!.metadata.creationTime!.year;
    final month =
        FirebaseAuth.instance.currentUser!.metadata.creationTime!.month;
    final day = FirebaseAuth.instance.currentUser!.metadata.creationTime!.day;
    final hour = FirebaseAuth.instance.currentUser!.metadata.creationTime!.hour;
    final minute =
        FirebaseAuth.instance.currentUser!.metadata.creationTime!.minute;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
        ),
        body: Container(
      color: Colors.white,
      child: Center(
        child: Column(children: [
          SizedBox(
            height: 100,
          ),
          Icon(
            Icons.account_box,
            size: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text('Username: ${username}',style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 20,
          ),
          Text('CREATED : ${day}-${month}-${year}',style: TextStyle(fontSize: 20)),
          
        ]),
      ),
    ));
  }
}
