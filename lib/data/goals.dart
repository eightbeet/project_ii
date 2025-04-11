import 'package:sqflite/sqflite.dart';

import 'db.dart';
import '../data/usage.dart';

class GoalData {
   int ?id;
   bool isActive;
   bool isAchieved;
   int duration;
   String kind;

   GoalData({this.id, required this.isActive, required this.isAchieved, required this.duration, required this.kind});
   
   @override
   String toString(){
      return "GoalData{ id: ${this.id} is_active: ${this.isActive} is_achieved: ${this.isAchieved} duration: ${this.duration} kind: ${this.kind}";
   }
}

class AppGoalsHelper {
  
  Future<List<Map<String, dynamic>>> getAllGoals() async {
    Database db = await AppDB().database;

    return await db.query('goals_data');
  }
   
  GoalData goalFormat(Map<String, dynamic> goal) {
     final {'id': id,
           'kind': kind,
           'duration': duration,
           'active_status': active_status,
           'achieve_status': achieve_status } = goal; 

     final isAchieved =  achieve_status == 1? true : false;
     final isActive = active_status == 1? true : false;

     return GoalData(id: id, isActive: isActive, isAchieved: isAchieved, duration: duration, kind: kind);
  }

  void insertGoal(GoalData goal) async {
    Database db = await AppDB().database;
    final err = await db.insert('goals_data', 
                              {'kind': goal.kind,
                              'duration': goal.duration,
                              'active_status': goal.isActive,
                              'achieve_status': goal.isAchieved }
                );

    // handle errors
  }

  void deleteGoal(int? id) async {
    Database db = await AppDB().database;
    final err = await db.delete('goals_data', where:'id = ?', whereArgs: [id]);
    // handle errors
  }

  void updateGoal(GoalData goal) async {
    Database db = await AppDB().database;
    final err = await db.update('goals_data', 
                                 {'kind': goal.kind,
                                 'duration': goal.duration,
                                 'active_status': goal.isActive,
                                 'achieve_status': goal.isAchieved },
                              where: 'id = ? ', whereArgs: [goal.id]);
  }

  void checkGoalCompletion(GoalData goal) async {

      if(goal.kind == 'Daily'){
         final daily = await AppUsageDBHelper().calculateTimeUsageDay();
         if(UsageTime().toHours(daily.toDouble()) >= goal.duration ) {
            goal.isAchieved = true;
            updateGoal(goal);
         }
      }
      if(goal.kind == 'Weekly'){
         final weekly = await AppUsageDBHelper().calculateTimeUsageWeek();
         if(UsageTime().toHours(weekly.toDouble())>= goal.duration) {
            goal.isAchieved = true;
            updateGoal(goal);
         }
      }
      if(goal.kind == 'Monthly'){
         final monthly = await AppUsageDBHelper().calculateTimeUsageMonth();
         if(UsageTime().toHours(monthly.toDouble()) >= goal.duration) {
            goal.isAchieved = true;
            updateGoal(goal);
         }
      }
  }
}
