import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layouts/home_layout.dart';
import 'package:todo/shared/bloc_observer.dart';

import 'modules/counter_screen/counter_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
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
