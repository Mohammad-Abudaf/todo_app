import 'package:bloc/bloc.dart';

abstract class AppStates{}

class AppInitialState extends AppStates{}
class AppChangeBottomNavState extends AppStates{}
class CreateAppDatabaseState extends AppStates{}
class InsertAppDatabaseState extends AppStates{}
class GetAppDatabaseState extends AppStates{}
class ChangeFloatingAppIconState extends AppStates{}

