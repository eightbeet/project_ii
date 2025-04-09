import 'dart:async';

import 'package:flutter/material.dart';

import '../data/data_achievements.dart';

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

  Future<List<Map<String, dynamic>>> achievements() async {

      return await AppAchievementsDBHelper().getAllAchievements();
  }

  Future<List<Map<String, dynamic>>> progressData() async { 

      return await AppAchievementsDBHelper().getProgressData();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Map <String, dynamic>>> (
      future: achievements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

       _achievements = snapshot.data!;
       achievementsCount = _achievements.length;

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title and Profile 
            FutureBuilder<List<Map <String, dynamic>>> (
            future: progressData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              }
            
            final data = snapshot.data!;
            final userProgressData = data[0];
            final nextLevelData = data[1];

            userLevel = userProgressData['current_level'];
            nextLevel = userProgressData['next_level'];

            final nextLevelXp = nextLevelData['min_xp'];
            currentXp = userProgressData['user_xp'];

            remainingXp = nextLevelXp - currentXp;
            progress = currentXp.toDouble() / nextLevelXp.toDouble();

            return Container(
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
           );})
            ,
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
                                           text: "${achievement['min_xp'] - currentXp}xp ",
                                           style: TextStyle(
                                             fontSize: 12,
                                             fontWeight: FontWeight.bold,
                                             color: Theme.of(context).colorScheme.primaryContainer,
                                           ),
                                         ),
                                         TextSpan(
                                           text: 'left',
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

