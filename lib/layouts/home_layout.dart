import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_screen/archived_screen.dart';
import 'package:todo/modules/done_screen/done_screen.dart';
import 'package:todo/modules/task_screen/task_screen.dart';
import 'package:todo/shared/componants/componants.dart';
import 'package:todo/shared/componants/contants.dart';

class HomeScreenLayout extends StatefulWidget {
  @override
  _HomeScreenLayoutState createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  int screenNumber = 0;
  bool isBottomSheetActivated = false;
  var keyScaffold = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var stateController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  Database database;
  var fabIcon = Icons.edit;

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
        onPressed: () {
          setState(() {
            if (isBottomSheetActivated) {
              if (formKey.currentState.validate()) {
                insertToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text)
                    .then((value) {
                  Navigator.pop(context);
                  isBottomSheetActivated = false;
                  setState(() {
                    fabIcon = Icons.edit;
                  });
                }).catchError((error) {
                  print('error ${error.toString()}');
                });
              }
            } else {
              setState(() {
                fabIcon = Icons.add;
              });
              isBottomSheetActivated = true;
              keyScaffold.currentState
                  .showBottomSheet((context) => Container(
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'title must not be empty';
                                  }

                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2021-05-03'),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  });
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Date',
                                prefix: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      ))
                  .closed
                  .then((value) {
                isBottomSheetActivated = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              }).catchError((){
                print ('error');
              });
            }
          });
        },
        child: Icon(fabIcon),
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
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline_rounded), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_rounded), label: 'archived'),
        ],
      ),
      body: tasks.length == 0? Center(child: CircularProgressIndicator(),): screensList[screenNumber],
    );
  }

  void createDataBase() async {
    database = await openDatabase('database3.db', version: 2,
        onCreate: (database, version) {
      database
          .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time Text, state TEXT)',
          )
          .then((value) => print('table created'))
          .catchError((error) {
        print('error when creating table ${error.toString()}');
      });
      print('database created');
    }, onOpen: (database) {
      getDataFormDataBase(database).then((value) {
        setState(() {
          tasks = value;
        });
      });
      print('database opened');
    });
  }

  Future insertToDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return database.transaction((txn) {
      return txn
          .rawInsert(
              "INSERT INTO tasks (title, date, time, state) VALUES ('$title', '$date', '$time', 'new')")
          .then((value) {
              print('$value inserted inside data base');
              getDataFormDataBase(database).then((value) {
                Navigator.pop(context);
                setState(() {
                  tasks = value;
                });
              });
      }).catchError((error) {
        print('there is error when inserting in data base ${error.toString()}');
      });
    });
  }
  
  Future<List<Map>> getDataFormDataBase(database) async{
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
