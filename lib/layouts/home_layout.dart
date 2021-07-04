import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_screen/archived_screen.dart';
import 'package:todo/modules/done_screen/done_screen.dart';
import 'package:todo/modules/task_screen/task_screen.dart';

class HomeScreenLayout extends StatefulWidget {
  @override
  _HomeScreenLayoutState createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  int screenNumber = 0;
  bool isBottomSheetActivated = false;
  var keyScaffold = GlobalKey<ScaffoldState>();
  var title = TextEditingController();
  var state = TextEditingController();
  var date = TextEditingController();
  var database;
  List<Widget> screensList = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: keyScaffold,
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
        onPressed: (){
          setState(() {
            if(isBottomSheetActivated){
               Navigator.pop(context);
               isBottomSheetActivated = false;
            } else {
              isBottomSheetActivated = true;
              keyScaffold.currentState.showBottomSheet(
                      (context) => Column(
                        children: [

                        ],
                )
              );
            }
          });
        },
        child: isBottomSheetActivated? Icon(Icons.add):Icon(Icons.edit),
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
  void createDataBase() async {
    database = openDatabase(
      'todo_database.db',
      version: 1,
      onCreate: (database, version){
        database.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, task TEXT, date TEXT, state TEXT)',
        ).then((value) => print ('table created')).catchError((error){
          print ('error when creating table ${error.toString()}');
        });
        print('database created');
      },
      onOpen: (database){
        print ('database opened');
      }
    );

  }
}
