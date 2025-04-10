/*
achievement_system {

   load_achievements_data

      do_updates {
      
         check_personal_goals {
            if goals_complete then award_bonus_xp
         }
      }
      
      advance() {
         if user_has_achieved_a_goal {
            calculate_xp
            update_user_current_xp with calculated_xp in_database;
         }

         if user_current_xp >= next_level_xp {
            then update_user_progresss_in_database {
               update_level
               update_xp
            }
            then update_user_achieveents_in_database

            then update_accessible_media ??? 

            then notify_user_of_upgrade
         }
      }
   }


   if has_reached_next_level_xp {
      
      award_achievement(pop up) @maybe achievement_animation
      
      update_achievments_list_in_ui

      update_user_level_in_ui

      unlock_perks(audio, video, art)
      
      notifiy_user_of unlocked_perks //?? 

   }
   
   DETERMINE {
      
      goals_to_reward_ratio @ie 
      how_much_xp_to_award @ie worth_of_1xp,
      
   }
}
*/

import 'dart:math';
import 'dart:async';

import '../data/goals.dart';
import '../data/data_achievements.dart';

import 'package:sqflite/sqflite.dart';
import '../data/db.dart';

class AppAchievementService {
   
   int currentXp = 0;
   int nextLevelXp = 0;
   int currentLevel = 0;
   int achievementIndex = 0;
   int bonusXp = 0;
   List<GoalData>goals = [];

   void update() async {
      // PROBLEM
      final progress_data = await AppAchievementsDBHelper().getProgressData(); 

      final goal_data = await AppGoalsHelper().getAllGoals();

      for(var item in goal_data) {
        final goal = AppGoalsHelper().goalFormat(item);
        goals.add(goal);
      }

      currentLevel = progress_data[0]['current_level'];
      achievementIndex = progress_data[0]['achievement_index'];
      currentXp = progress_data[0]['user_xp'];
      nextLevelXp = progress_data[1]['min_xp'];

      for(var goal in goals) {
         AppGoalsHelper().checkGoalCompletion(goal);
      }

      for(var goal in goals) {
         print("GOAL ${goal}");
         if(goal.isActive && goal.isAchieved) {
            goal.isActive = false;
            currentXp += _calculateXpBonusFromGoal(goal); 
            AppAchievementsDBHelper().updateProgressData(currentXp, currentLevel, achievementIndex); 
            AppGoalsHelper().updateGoal(goal);
         }
      }

      if(currentXp >= nextLevelXp) {
         print("curr xp ${currentXp}: next xp ${nextLevelXp}");
         print("Weeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee NOOOOOOOOOOOOOoooooooooooooooooooo");
         achievementIndex = achievementIndex + 1;
         AppAchievementsDBHelper().updateProgressData(currentXp, currentLevel, achievementIndex); 
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

      // Database db = await AppDB().database;
      // await db.update('progress_data', 
      //                            {'next_level': 1, 'achievement_index': 0},
      //                         where: 'id = ? ', whereArgs: [1]);
}
