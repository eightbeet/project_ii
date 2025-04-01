import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'utils.dart';
import 'timer.dart';
import 'block.dart';
import 'goals.dart';
import 'achievements.dart';
import 'settings.dart';
import 'media.dart';
import 'stats.dart';

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
               TimerSection(),
               UsageSection(),
               ChartsSection(),
            ],
         ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Project II")),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: StatsWidget(), 
          ),
        ),
        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.block),
            label: 'Block',
          ),
          NavigationDestination(
            icon: Icon(Icons.av_timer),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_vert),
            label: 'Other',
          ),
        ],
      )
     );
   }
}

class TimerSection extends StatelessWidget {

  final List<int> chipValues = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ApplyBoxShadow(0.3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Container( 
                  padding: EdgeInsets.all(10), 
                  child: Text("Start Timer", style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                const Icon(Icons.star),
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
  Future<List<Map<String, int>>> fetchTimeData() async {
    await Future.delayed(Duration(seconds: 2)); 
    return [
      {'tag' :  30, 'hours': 12, 'minutes': 30, 'seconds': 45},
      {'tag' :  4, 'hours': 2, 'minutes': 15, 'seconds': 30},
      {'tag' :  1, 'hours': 8, 'minutes': 5, 'seconds': 59},
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

        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: ApplyBoxShadow(0.3),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            Wrap(
              spacing: 16.0, 
              runSpacing: 16.0,
              alignment: WrapAlignment.center,
              children: timeData.map((data) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${data['tag']} Usage',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.normal,
                            color: Colors.black, 
                          ),
                        ),

                        Text(
                          '${data['hours']} Hrs',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                          ),
                        ),

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
            ),],),
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
            margin: EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
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
                        fontSize: 24,
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
