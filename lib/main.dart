import 'add_blop_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sonime_app/login.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/req.dart';
import 'product_overview.dart';
import '../blog_detail.dart';
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
        value:Req(),
        ),
        ChangeNotifierProvider.value(
        value: Products(),
       ),
      ],
      //this suppose to be material app
      child: MyApp())
       
    );
}
// i was tring to work on the auth 
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes:  {
    AddBlog.routeName: ((context) => AddBlog()),
    // When navigating to the "/" route, build the FirstScreen widget.
    BlogDetailScreen.routeName: (context) =>  BlogDetailScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
  
  }, 
      home: Scaffold(
    body: StreamBuilder<User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        
        else if(snapshot.hasError) {
          return Center(child: Text('something went wrong'),);
        }
        else if(snapshot.hasData) {
          return ProductOverView();

        }
        else if(snapshot.connectionState == ConnectionState.active) {
           return LoginScreen();
        }
        else {return Center(child: CircularProgressIndicator());}
        
      }
    )
    ));  
    
  }
}