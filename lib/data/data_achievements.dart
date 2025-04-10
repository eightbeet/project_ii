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
      final list1 = await db.rawQuery('SELECT * FROM progress_data WHERE id = 1');
      final at = list1[0]['next_level'];
      final list2 = await db.rawQuery('SELECT * FROM level_data WHERE id = ${at}');

      final a = await db.query('progress_data') ;
      final b = await db.query('level_data') ;
      print("PROGRESS DATA ${a}");
      print("LEVEL DATA ${b}");
      return [list1[0], list2[0]];
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
    print('IDXX: ${idx}');
    return await db.rawQuery('SELECT * FROM achievements_data WHERE id BETWEEN 0 AND ${idx}');
  }
 
  void initProgressData(int xp, int level) async {
    Database db = await AppDB().database;
    int nextLevel = level == LevelData.maxLevel ? LevelData.maxLevel : level + 1;
    final err = await db.insert('progress_data', 
                               {'id': 1, 'user_xp': xp, 'current_level': level, 'next_level': nextLevel});
    printStatusInfo(err, 'progress_data');
  }  
  
  void updateProgressData(int xp, int level, int achievementIndex) async {
      Database db = await AppDB().database;
      final int id = 1;
      final int nextLevel = level == LevelData.maxLevel ? level : LevelData.maxLevel;
      final err = await db.update('progress_data', {'user_xp': xp, 'current_level': level,
                                                    'next_level': nextLevel, 'achievement_index': achievementIndex}
                                                   , where: 'id = ?', whereArgs: [id]);
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
   
   initProgressData(0, 0);
  }

}


