import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Req with ChangeNotifier{
   final items = <List> [];
  void PostRequest (todo) async {
    const url = 'https://yuyu-46e81-default-rtdb.firebaseio.com/names.json';
    final response = await http.post(Uri.parse(url),body: json.encode(todo));
    final extractedData = json.decode(response.body) as List;
  }
}