import 'package:flutter/material.dart';
import 'package:todo/shared/componants/componants.dart';
import 'package:todo/shared/componants/contants.dart';

class TasksScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index]),
        separatorBuilder: (context, index) => Container(
          color: Colors.grey[300],
          height: 1.0,
          width: double.infinity,
        ),
        itemCount: tasks.length,
    );
  }
}