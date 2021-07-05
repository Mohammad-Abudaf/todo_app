import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_screen/archived_screen.dart';
import 'package:todo/modules/done_screen/done_screen.dart';
import 'package:todo/modules/task_screen/task_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super (AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int screenNumber = 0;
  Database database;
  List<Widget> screensList = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List<Map> tasks = [];


  void changeIndex(int index){
    screenNumber = index;
    emit(AppChangeBottomNavState());
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
               tasks = value;
               print(tasks);
               emit(GetAppDatabaseState());
          });
          print('database opened');
        }).then((value) {database = value; emit(CreateAppDatabaseState());}).catchError((error) => print("error opening database $error"));
  }

  Future insertToDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return database.transaction((txn) {
      return txn.rawInsert(
          "INSERT INTO tasks (title, date, time, state) VALUES ('$title', '$date', '$time', 'new')")
          .then((value) {
        print('$value inserted inside data base');
        emit(InsertAppDatabaseState());
        getDataFormDataBase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(GetAppDatabaseState());
        });
      }).catchError((error) {
        print('there is error when inserting in data base ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFormDataBase(database) async{
    return await database.rawQuery('SELECT * FROM tasks');
  }

  IconData fabIcon = Icons.edit;
  bool isShown;

  void changeButtonIcon({ @required IconData icon, @required isShown}){
        this.isShown = isShown;
        fabIcon = icon;
        emit(ChangeFloatingAppIconState());
  }
}
