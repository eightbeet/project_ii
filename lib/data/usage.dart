import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class AppUsageDBHelper {

 static final AppUsageDBHelper _instance = AppUsageDBHelper._internal();
 factory AppUsageDBHelper() => _instance;
 static Database? _database;

 AppUsageDBHelper._internal();

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
 }

 Future<int> insertSave(int timeSaved) async {
    Database db = await database;
    return await db.insert('usage_data', {'date': DateTime.now().toIso8601String(), 'usage_time': timeSaved});
 }

 Future<List<Map<String, dynamic>>> getAllUsage() async {
    Database db = await database;
    return await db.query('usage_data');
 }

 Future<List<Map<String, dynamic>>> getInDayUsage() async {
    Database db = await database;
    DateTime now = DateTime.now();
    DateTime startOfMonth = now.subtract(Duration(days: 1)); // Start 1 day ago

    return await db.query(
      'usage_data',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfMonth.toIso8601String(), now.toIso8601String()],
    );
  }

 Future<List<Map<String, dynamic>>> getInWeekUsage() async {
    Database db = await database;
    DateTime now = DateTime.now();
    DateTime startOfMonth = now.subtract(Duration(days: 6)); // Start 7 days ago

    return await db.query(
      'usage_data',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfMonth.toIso8601String(), now.toIso8601String()],
    );
  }

 Future<List<Map<String, dynamic>>> getInMonthUsage() async {
    Database db = await database;
    DateTime now = DateTime.now();
    DateTime startOfMonth = now.subtract(Duration(days: 30)); // Start 30 days ago

    return await db.query(
      'usage_data',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfMonth.toIso8601String(), now.toIso8601String()],
    );
  }

  Future<num> calculateTimeUsageDay() async {
      List<Map<String, dynamic>> usage = await getInDayUsage();
      num totalTime = 0;

      for (var use in usage) {
            totalTime += use['usage_time'];
      }
      return totalTime;
   }

   Future<num> calculateTimeUsageWeek() async {
      List<Map<String, dynamic>> usage = await getInWeekUsage();
      num totalTime = 0;

      for (var use in usage) {
            totalTime += use['usage_time'];
      }
      return totalTime;
   }

   Future<num> calculateTimeUsageMonth() async {
      List<Map<String, dynamic>> usage = await getInMonthUsage();
      num totalTime = 0;

      for (var use in usage) {
            totalTime += use['usage_time'];
      }
      return totalTime;
   }

   Future<int> _clearAllUsageData() async {
        Database db = await database;
        return await db.delete('usage_data'); 
    }
}

class AppUsageDBModify {

   void saveUsageData(int timeSaved) async {
      int result = await AppUsageDBHelper().insertSave(timeSaved);
      if (result != 0) {
         print("Time saved successfully");
      } else {
          print("Failed to save time");
      }
   }

   void clearUsageData() => AppUsageDBHelper()._clearAllUsageData();
}

