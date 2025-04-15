import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';
import 'timer.dart';
import 'block.dart';
import 'goals.dart';
import 'achievements.dart';
import 'settings.dart';
import 'media.dart';
import 'stats.dart';
import 'chat.dart';
import 'dummy.dart';
import '../data/usage.dart';

late final SharedPreferences prefs;

class AppMainWidget extends StatefulWidget {
  const AppMainWidget({super.key});

  @override
  State<AppMainWidget> createState() => _AppMainWidgetState();
}

class _AppMainWidgetState extends State<AppMainWidget> {

  int currentPageIndex = 0;

  Widget HomePageWidgets() {
      return SingleChildScrollView(
         child: Column(
            children: <Widget>[
               //  AppShillSection(),
               TimerSection(),
               UsageSection(),
               ChartsSection(),
               MediaWidget(),
            ],
         ),
      );
  }

  void _navigateToAiChat() async { 
      final prefs = await SharedPreferences.getInstance();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Chat(prefs: prefs),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Project II"),
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: [
               HomePageWidgets(),
               // AppBlockSettingsScreen(),
               BlockWidget(),
               TimerWidget(),
               GoalsWidget(),
               AchievementsWidget(),
               StatsWidget(),
            ][currentPageIndex], 
          ),
        ),
        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.block),
            selectedIcon: Icon(Icons.block_outlined),
            label: 'Block',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.bullseye),
            label: 'Goals',
          ),
          NavigationDestination(
            selectedIcon: Icon(MdiIcons.trophy),
            icon: Icon(MdiIcons.trophyOutline),
            label: 'Progress',
          ),
          NavigationDestination(
            selectedIcon: Icon(MdiIcons.chartBar),
            icon: Icon(MdiIcons.chartBarStacked),
            label: 'Stats',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAiChat,
        tooltip: 'Increment',
        child: ImageIcon(AssetImage('icons/ai.png')),
      ), 
     );
   }
}

class TimerSection extends StatelessWidget {

  final List<int> chipValues = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
         color: Theme.of(context).colorScheme.surfaceContainerHigh,
         borderRadius: BorderRadius.circular(12),
         gradient: LinearGradient(
            colors:[
               Theme.of(context).colorScheme.tertiary,
               Theme.of(context).colorScheme.tertiaryFixed,
               Theme.of(context).colorScheme.onSurface
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Container( 
                  padding: EdgeInsets.all(10), 
                  child: Text("Instant Timer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                const Icon(Icons.timer_rounded),
            ],
          ),
          Center(
            child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
               onPressed: () {
                  TimerWidget.startInstantTimer(context, 0, 2, 5);
                  // [TODO]:Add Action
              },
              child: Text('Start', style: TextStyle(fontSize: 20)),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: chipValues.map((chipValue) {
              return GestureDetector(
                onTap: () {
                  // [TODO]: Add Action
                  print("Clicked on chip with value: $chipValue");
                },
                child: Chip(
                  label: Text(chipValue.toString(), style: TextStyle(color: Theme.of(context).primaryColor),),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  elevation: 0, 
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                      color:  Theme.of(context).primaryColor, 
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(18),   
                      right: Radius.circular(18),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ]
      ),
    );
  }
}

class UsageSection extends StatelessWidget {
   // [DUMMYDATA]
   // [DUMMYWAIT]

  Map<String, dynamic> timeFormat(String tag, int seconds) {
     int second = seconds % 60;
     int minute = (seconds ~/ 60) % 60;
     int hour = (seconds ~/ 3600);
     return {'tag' : tag, 'hours': hour, 'minutes': minute, 'seconds': second};
  }

  Future<List<Map<String, dynamic>>> timeData() async {

    final daily = await AppUsageDBHelper().calculateTimeUsageDay();
    final weekly = await AppUsageDBHelper().calculateTimeUsageWeek();
    final monthly = await AppUsageDBHelper().calculateTimeUsageMonth();

    return [
      timeFormat('Daily', daily.toInt()),
      timeFormat('Weekly', weekly.toInt()),
      timeFormat('Monthly', monthly.toInt()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: timeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final timeData = snapshot.data!;

      return Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Usage',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: timeData.map((data) {
                return Container(
                   width: 150, 
                   height: 200,
                   decoration: BoxDecoration(
                     color: Theme.of(context).colorScheme.primaryContainer,
                     borderRadius: BorderRadius.circular(12),
                   ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['tag']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${data['hours']} Hrs',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              '${data['minutes']} Min',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${data['seconds']} Secs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}

class ChartsSection extends StatelessWidget {
   // [DUMMYDATA]
   // [DUMMYWAIT]
  Future<List<Map<String, int>>> fetchTimeData() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      {'hours': 12, 'minutes': 30, 'seconds': 45},
      {'hours': 2, 'minutes': 15, 'seconds': 30},
      {'hours': 8, 'minutes': 5, 'seconds': 59},
      {'hours': 23, 'minutes': 59, 'seconds': 59},
      {'hours': 10, 'minutes': 25, 'seconds': 13},
      {'hours': 5, 'minutes': 59, 'seconds': 59},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, int>>>(
      future: fetchTimeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final timeData = snapshot.data!;

        List<BarChartGroupData> barChartData = timeData.map((data) {
          return BarChartGroupData(x: data['hours'] ?? 0, barRods: [
            BarChartRodData(
              toY: (data['hours'] ?? 0).toDouble(),
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.zero,
            ),
          ]);
        }).toList();

        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(show: true),
                      gridData: FlGridData(show: true),
                      barGroups: barChartData,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
