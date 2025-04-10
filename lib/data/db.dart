import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data_achievements.dart'; 

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
      return await openDatabase(path, version: 7, onCreate: _onCreate, onUpgrade: _onUpgrade);
   }
   
   Future _onCreate(Database db, int version) async {
   
      await db.execute(
           'CREATE TABLE usage_data(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, usage_time INTEGER)'
      );
   }

}

Future _onUpgrade(Database db, int oldVersion, int newVersion ) async {
      var batch = db.batch(); 
      if(oldVersion < 7) {

         await db.execute(
              'DROP TABLE goals_data'
         );

         await db.execute(
              'CREATE TABLE goals_data(id INTEGER PRIMARY KEY AUTOINCREMENT, kind TEXT,duration INTEGER, active_status INTEGER,achieve_status INTEGER)'
         );

         // await db.execute(
         //    'ALTER TABLE progress_data ADD achievement_index INTEGER'
        // );

         // await db.execute(
         //    'UPDATE progress_data SET achievement_index = 0'
         // );

         // await db.execute(
         //      'CREATE TABLE level_data(id INTEGER PRIMARY KEY AUTOINCREMENT, level INTEGER, min_xp INTEGER)'
         // );
         
         // await db.execute(
         //      'CREATE TABLE progress_data(id INTEGER PRIMARY KEY, user_xp INTEGER, current_level INTEGER, next_level INTEGER)'
         // );
         
         // await db.execute(
         //      'CREATE TABLE achievements_data(id INTEGER PRIMARY KEY AUTOINCREMENT, achievement_kind TEXT, min_xp INTEGER, description TEXT)'
         // );

         // AppAchievementsDBHelper().initAll();
      }

}

