import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class AppDB {

   static final AppDB _instance = AppDB._internal();
   factory AppDB() => _instance;
   static Database? _database;
   
   AppDB._internal();
   
   Future<Database> get database async {
      if (_database != null) return _database!;
      _database = await _initDatabase();
      return _database!;
   }
   
   Future<Database> _initDatabase() async {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'app.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
   }
   
   Future _onCreate(Database db, int version) async {
   
      await db.execute(
           'CREATE TABLE usage_data(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, usage_time INTEGER)'
      );
   
      await db.execute(
           'CREATE TABLE level_data(id INTEGER PRIMARY KEY AUTOINCREMENT, level INTEGER, min_xp INTEGER)'
      );
      
      await db.execute(
           'CREATE TABLE progress_data(id INTEGER PRIMARY KEY AUTOINCREMENT, user_xp INTEGER, current_level INTEGER, next_level INTEGER)'
      );

      await db.execute(
           'CREATE TABLE achievements_data(id INTEGER PRIMARY KEY AUTOINCREMENT, achievement_kind TEXT, min_xp INTEGER, description TEXT)'
      );
   }

}

