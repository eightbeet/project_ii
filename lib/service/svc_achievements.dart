import 'dart:math';
import 'dart:async';


import 'package:flutter/material.dart';

import '../data/goals.dart';
import '../data/data_achievements.dart';

import 'package:sqflite/sqflite.dart';
import '../data/db.dart';

class AppAchievementService {
   int currentLevel = 0;
   int nextLevel = 0; 
   int achievementIndex = 0;
   int userXp = 0;
   int nextLevelXp = 0;

   List<GoalData>goals = [];

   void update(BuildContext context) async {
      // _resetProgress();

      final progress_data = await AppAchievementsDBHelper().getProgressData(); 
      final level_data = await AppAchievementsDBHelper().getLevelData(); 
      final goal_data = await AppGoalsHelper().getAllGoals();

      currentLevel = progress_data[0]['current_level'];
      nextLevel = progress_data[0]['next_level'];
      userXp = progress_data[0]['user_xp'];
      achievementIndex = progress_data[0]['achievement_index'];
      
      nextLevelXp = level_data[0]['min_xp'];


      for(var item in goal_data) {
        final goal = AppGoalsHelper().goalFormat(item);
        goals.add(goal);
      }

      for(var goal in goals) {
         AppGoalsHelper().checkGoalCompletion(goal);
      }

      for(var goal in goals) {
         if(goal.isActive && goal.isAchieved) {
            goal.isActive = false;
            userXp += _calculateXpBonusFromGoal(goal); 
            AppGoalsHelper().updateGoal(goal);
         }
      }
      
      AppAchievementsDBHelper().updateProgressData(ProgressData(
                                                      currentLevel: currentLevel,
                                                      nextLevel: nextLevel,
                                                      userXp: userXp, 
                                                      achievementIndex: achievementIndex 
    )); 

      if(userXp >= nextLevelXp) {
         achievementIndex = achievementIndex + 1;
         currentLevel = currentLevel + 1;
         nextLevel = nextLevel + 1;
         AppAchievementsDBHelper().updateProgressData(ProgressData(
                                                      currentLevel: currentLevel,
                                                      nextLevel: nextLevel,
                                                      userXp: userXp, 
                                                      achievementIndex: achievementIndex 
            ));
         notifyUser(context);
      }

      
   }

   int _calculateXpBonusFromGoal(GoalData goal) {

      if(goal.kind == 'Daily'){return ((goal.duration / 24.0) * 120.0).toInt(); }
      if(goal.kind == 'Weekly'){return ((goal.duration / 24.0) * 7 * 120.0).toInt(); }
      if(goal.kind == 'Monthly'){return ((goal.duration / 24.0) * 30 * 120.0).toInt(); }
      else { 
         final random = Random();
         return ((goal.duration / 24.0) * (random.nextInt(goal.duration * 2) * 120.0)).toInt(); 
      }
      
   }

   void _resetProgress() async {
      Database db = await AppDB().database;
      await db.update('progress_data',
                      {'user_xp': 0, 'next_level': 1, 'achievement_index': 0},
                      where: 'id = ? ', whereArgs: [1]);
  }

  void notifyUser(BuildContext context) {

      final textColor = Theme.of(context).colorScheme.onPrimary;
      final snackBarActionBgColor = Theme.of(context).colorScheme.primaryFixed.withValues(alpha: 0.2); 
      final snackBarTextColor = Theme.of(context).colorScheme.onPrimary;
      final snackBarBGColor = Theme.of(context).colorScheme.primary;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: 'hide',
              onPressed: () {},
              backgroundColor: snackBarActionBgColor,
              textColor: snackBarTextColor,
            ),
            content: Text('New Achievement Unlocked!', style : TextStyle( 
            color: textColor,
            )),
            duration: const Duration(milliseconds: 20000),
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                     topLeft: Radius.zero,
                     bottomLeft: Radius.circular(20),
                     topRight: Radius.circular(20),
                     bottomRight: Radius.zero,
            )),
            backgroundColor: snackBarBGColor,
          ),
      );
   }
}



