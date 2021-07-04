import 'package:flutter/material.dart';
import 'package:todo/modules/archived_screen/archived_screen.dart';
import 'package:todo/modules/done_screen/done_screen.dart';
import 'package:todo/modules/task_screen/task_screen.dart';

class HomeScreenLayout extends StatefulWidget {
  @override
  _HomeScreenLayoutState createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  int screenNumber = 0;

  List<Widget> screensList = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Todo',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenNumber,
        elevation: 0.0,
        onTap: (index) {
          setState(() {
            screenNumber = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), label: 'Tasks'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded), label: 'Done'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_rounded), label: 'archived'
          ),
        ],
      ),
      body: screensList[screenNumber],
    );
  }
}
