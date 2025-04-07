
import 'package:flutter/material.dart';

class AchievementsWidget extends StatefulWidget {
  @override
  _AchievementsWidgetState createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {
  // Simulated user data 
  int currentXP = 1200; 
  int nextMilestone = 1500; 
  List<Map<String, String>> achievements = [
    {'title': 'Beginner', 'description': 'Completed your first task.'},
    {'title': 'Intermediate', 'description': 'Completed 10 tasks.'},
    {'title': 'Advanced', 'description': 'Completed 50 tasks.'},
    {'title': 'Master', 'description': 'Completed 100 tasks.'},
  ];

  // User's level based on currentXP and nextMilestone
  int get userLevel {
    if (currentXP >= 1000) return 10; 
    if (currentXP >= 500) return 8;   
    if (currentXP >= 100) return 5;   
    return 1;                         
  }

  int get nextLevel {
    return userLevel + 1;
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentXP / nextMilestone;
    int remainingXP = nextMilestone - currentXP;

    int achievementsCount = achievements.length;
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
                    text: ' $remainingXP XP ',
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
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  var achievement = achievements[index];
                  return ListTile(
                      title: Text(
                        achievement['title']!,
                        style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(achievement['description']!),
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
}

