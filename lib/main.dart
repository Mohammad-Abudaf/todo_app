import 'package:flutter/material.dart';
import 'package:todo/layouts/home_layout.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreenLayout(),
    );
  }
}
