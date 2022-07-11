import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class recipe {
  // final instructions;
  String id;
  String name;
  String img;
  String prep;
  recipe(
      {required this.id,
      required this.name,
      required this.img,
      required this.prep});
}

class Products with ChangeNotifier {
  var _items = [];
//final _test = recipe(id: '',name: 'name', img: 'argo');
  logout() {
    FirebaseAuth.instance.signOut();
  }

  Future getspecificuser(email) async {
    final userdetail = await FirebaseFirestore.instance
        .collection('users')
        .doc('RGyD32bvgVWPc324gKsoHcc9UaC3')
        .snapshots();
//final username = userdetail.forEach((element) { element['name'];});
    print(await userdetail.forEach((element) {
      element.id;
    }));
  }

  Future fetchcomment() async {
    final posts = await FirebaseFirestore.instance
        .collection('products')
        .doc('8ooLDoL1c2uAXAo3AHmY')
        .collection('comments')
        .doc('uFFTIgaaS7Aj0LefHR9v')
        .get()
        .then((value) => (value['comment']));
    return print(posts);

// try{
//    return posts.get().then((value) => value.id);

    //.collection('comments').get().then((value) => value.docs.forEach((element) {element.id;}));
    // return posts.docs.forEach((element) { element.id;});
// }
// catch(e) {}
  }

  Future fetchCommentNumber(docId) async {
    final result = await FirebaseFirestore.instance
        .collection('products')
        .doc(docId)
        .collection('comments')
        .snapshots()
        .length;
    return result;
  }

  Future<void> senduserdetails(username, email) async {
    final ref = await FirebaseFirestore.instance.collection('users');
    ref.add({'name': username, 'email': email});
  }

  Future<void> fetchrecipe() async {
    const bm = 'https://my-blog-project-73e32-default-rtdb.firebaseio.com/';
    const url = 'https://www.themealdb.com/api/json/v1/1/search.php?f=a';
    try {
      final response = await http.get(Uri.parse(url));
      //final responsed = await http.post(Uri.parse(bm),body: {'name': 'ijp'});
      print('');
      var loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //var tit = recipe(id: '', name: 'sonimes', img: 'imitate',prep: '');
      // print(products);
      extractedData['meals'].forEach((value) => {
            loadedProducts.add(recipe(
                id: value['idMeal'],
                name: value['strMeal'],
                img: value['strMealThumb'],
                prep: value['strInstructions'])),

            //_loadedProducts.add(
            // recipe(name: value['strMeal'] ,instructions:value["strInstructions"] ,img:value['strMealThumb'])
            //  )
          });

      _items = loadedProducts;
      //print(_items[0].img);
      print(_items[0].prep);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  get getItems {
    return _items;
    // return [..._items];
    //_items;
    //
    //
  }
}
