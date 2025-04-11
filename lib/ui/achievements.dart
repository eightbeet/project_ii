import 'dart:async';

import 'package:flutter/material.dart';


import '../data/data_achievements.dart';
import '../service/svc_achievements.dart';

class AchievementsWidget extends StatefulWidget {
  @override
  _AchievementsWidgetState createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {
  
  int userLevel = 0;
  int nextLevel = 0;
  int currentXp = 0;
  int remainingXp = 0;
  int achievementsCount = 0;

  double progress = 0;
  List<Map<String, dynamic>> _achievements = [];


  Future<Map<String, dynamic>> getAllData() async {
      final data_achievements = await AppAchievementsDBHelper().getAllAchievements();
      final data_progress = await AppAchievementsDBHelper().getProgressData();
      final data_level = await AppAchievementsDBHelper().getLevelData();
      return {'achievements': data_achievements, 'progress':  data_progress, 'level': data_level};
  }

  @override
  Widget build(BuildContext context) {

    
   AppAchievementService().update(context);

    return FutureBuilder<Map<String, dynamic>> (
      future: getAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error; Top: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print ('No data available');
        }

       final data = snapshot.data!;
       _achievements = data['achievements']!;
       final progressData = data['progress'];
       final nextLevelData = data['level'];

       achievementsCount = _achievements.length;

       final userProgressData = progressData[0];
       final userNextLevelData = nextLevelData[0];

       userLevel = userProgressData['current_level'];
       nextLevel = userProgressData['next_level'];

       final nextLevelXp = userNextLevelData['min_xp'];
       currentXp = userProgressData['user_xp'];
       remainingXp = nextLevelXp - currentXp;
       progress = currentXp.toDouble() / nextLevelXp.toDouble();

       return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title and Profile 
             Container(
              padding: EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // User Avatar with Level Overlay
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Positioned(
                      bottom: -6, // Position the level circle below the icon
                      left: 20,  // Center the circle horizontally
                      child: Container(
                        width: 24,  
                        height: 24, 
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$userLevel', 
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,  
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ),
            SizedBox(height: 20),
            Padding(
            padding: EdgeInsets.all(16),
            child: Column( 
            children: [ 
            Text('Progress to next milestone'),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress > 1 ? 1.0 : progress,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              color: Theme.of(context).colorScheme.primary,
              minHeight: 24,
              borderRadius: BorderRadius.circular(20),
            ),

            SizedBox(height: 10),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: ' $remainingXp XP ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                  TextSpan(
                    text: 'left until level $nextLevel is reached',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            ],
            ),
            ),
            Divider(),

            Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            child: Text(
              '$achievementsCount Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
               ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                  itemCount: _achievements.length,
                  itemBuilder: (context, index) {
                    var achievement = _achievements[index];
                    return ListTile(
                        title: Text(
                          achievement['achievement_kind']!,
                          style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(achievement['description']!),
                        trailing: RichText(
                                     text: TextSpan(
                                       children: [
                                         TextSpan(
                                           text: "+${achievement['min_xp']}",
                                           style: TextStyle(
                                             fontSize: 12,
                                             fontWeight: FontWeight.bold,
                                             color: Theme.of(context).colorScheme.primaryContainer,
                                           ),
                                         ),
                                         TextSpan(
                                           text: ' gained',
                                           style: TextStyle(
                                             fontSize: 10,
                                             fontWeight: FontWeight.bold,
                                             color: Theme.of(context).colorScheme.primary,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                        leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                      child: CircleAvatar(radius: 17, backgroundColor: Theme.of(context).colorScheme.primary),
                                      ),
                     );
                    },
                    separatorBuilder: (context, index) => const Divider(height: 3),
                  
                 ),
             ),
         ], 
      );
     }
    );
   }
}



