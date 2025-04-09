import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'db.dart';

class AppUsageDBHelper {

 Future<int> insertSave(int timeSaved) async {
    Database db = await AppDB().database;
    return await db.insert('usage_data', {'date': DateTime.now().toIso8601String(), 'usage_time': timeSaved});
 }

 Future<List<Map<String, dynamic>>> getAllUsage() async {
    Database db = await AppDB().database;
    return await db.query('usage_data');
 }

 num sumUsageTimes(int days, List<Map<String, dynamic>> usage) {
     DateTime now = DateTime.now();
     num sum = 0;
     for(var datum in usage) {
       final d =  DateTime.parse("${datum['date']}Z");
       final utc_d = DateTime(d.year, d.month, d.day);
       final utc_now = DateTime(now.year, now.month, now.day - days);
       if(utc_d.isAtSameMomentAs(utc_now)) {
          sum += datum['usage_time'];
       }
   }
   return sum;
 }

 Future<List<dynamic>> calculateTimeUsageDaysPro(int days) async {
   
    List<dynamic> data = [];
    List<Map<String, dynamic>> usage = await getInWeekUsage();

    for(int dys = 0; dys<=days; dys++) {
       num _sum = sumUsageTimes(dys, usage);
       data.add(_sum);
    }
    return data;
 }

 Future<List<Map<String, dynamic>>> getInDayUsage() async {
    Database db = await AppDB().database;
    DateTime now = DateTime.now();
    DateTime startOfDay =  DateTime.utc(now.year, now.month, now.day, 0, 0, 0, 0);
    // now.subtract(Duration(days: 1)); [BUG] // Start 1 day ago 

    return await db.query(
      'usage_data',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfDay.toIso8601String(), now.toIso8601String()],
    );
  }

 Future<List<Map<String, dynamic>>> getInWeekUsage() async {
    Database db = await AppDB().database;
    DateTime now = DateTime.now();
    DateTime startOfMonth = now.subtract(Duration(days: 6)); // Start 7 days ago

    return await db.query(
      'usage_data',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfMonth.toIso8601String(), now.toIso8601String()],
    );
  }

 Future<List<Map<String, dynamic>>> getInMonthUsage() async {
    Database db = await AppDB().database;
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
        Database db = await AppDB().database;
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

   void clearUsageData() {

      AppUsageDBHelper()._clearAllUsageData();
   }
}

