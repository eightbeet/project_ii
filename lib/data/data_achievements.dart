import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'db.dart';

class AchievementData {
   int minXp;
   String kind;
   String description;

   AchievementData({required this.minXp, required this.kind, required this.description});
}

class LevelData {
   int level;
   int minXp;
   static const int maxLevel = 12;
   
   LevelData({required this.level, required this.minXp});
}

class ProgressData {
   int userXp;
   int currentLevel;
   int nextLevel;
   int achievementIndex;
      
   ProgressData({required this.userXp,
                 required this.currentLevel,
                 required this.nextLevel,
                 required this.achievementIndex
   });
}

List<AchievementData> get achivementsData {

   return <AchievementData>[
      AchievementData(minXp: 10, kind: "noob", description: "Penger is your Benger, Noob!"),
   ];
}

List<LevelData> get levelsData {

   return <LevelData>[
      LevelData(level:1, minXp: 10),
      LevelData(level:2, minXp: 200),
   ];
}

class AppAchievementsDBHelper {

  void insertLevel(LevelData level) async {
    Database db = await AppDB().database;
    final err = await db.insert('level_data', { 'level': level.level, 'min_xp': level.minXp });
    printStatusInfo(err, 'level_data');
  }
   
  Future<List<Map<String, dynamic>>> getProgressData() async { 
     // Here be fire breathers.
      Database db = await AppDB().database;
      return await db.rawQuery('SELECT * FROM progress_data WHERE id = 1');
  }
   
  Future<List<Map<String, dynamic>>> getLevelData() async { 
      Database db = await AppDB().database;
      final x = await db.rawQuery("SELECT next_level FROM progress_data WHERE id =1");
      final idx = x[0]['next_level'];
      return await db.rawQuery("SELECT * FROM level_data WHERE id = ${idx}");
  }

  void insertAchievement(AchievementData achievement) async {
    Database db = await AppDB().database;
    final err = await db.insert('achievements_data', { 'achievement_kind': achievement.kind,
                           'min_xp': achievement.minXp, 'description': achievement.description});
    printStatusInfo(err, 'achievement_data');
  }

  Future<List<Map<String, dynamic>>> getAllAchievements() async {
    // More fire breathers.
    Database db = await AppDB().database;
    final x = await db.rawQuery("SELECT achievement_index FROM progress_data WHERE id =1");
    final idx = x[0]['achievement_index'];
    return await db.rawQuery('SELECT * FROM achievements_data WHERE id BETWEEN 0 AND ${idx}');
  }
 
  void initProgressData(int xp, int level, int _nextLevel) async {
    Database db = await AppDB().database;
    int nextLevel = level == LevelData.maxLevel ? LevelData.maxLevel : _nextLevel;
    final err = await db.insert('progress_data', 
                               {'id': 1, 'user_xp': xp, 'current_level': level, 'next_level': nextLevel});
    printStatusInfo(err, 'progress_data');
  }  
  
  void updateProgressData(ProgressData progress) async {
      Database db = await AppDB().database;
      final int nextLevel = progress.nextLevel == LevelData.maxLevel ? progress.nextLevel : LevelData.maxLevel;
      final err = await db.update('progress_data', {'user_xp': progress.userXp,
                                                    'current_level': progress.currentLevel,
                                                    'next_level': progress.nextLevel,
                                                    'achievement_index': progress.achievementIndex}
                                                   , where: 'id = ?', whereArgs: [1]);
      printStatusInfo(err, 'progress_data');
  }


  void printStatusInfo(int err, String itemKind) {
    if (err != 0) {
      print("successfully inserted ${itemKind} item.");
    } else {
      print("fialed to insert ${itemKind} item.");
    }
  }
   
  void initAll() async {

   for(var level in levelsData) {
   
       insertLevel(level); 
   }
   
   for(var achievement in achivementsData) {
   
       insertAchievement(achievement);
   }
   
   // initProgressData(0, 0, 0);
  }

}


