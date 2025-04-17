import 'dart:ui';

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
import 'shimmer.dart';

import '../data/usage.dart';
import '../data/about.dart';
import '../data/media.dart';
import '../data/quotes.dart';

late final SharedPreferences prefs;

class AppMainWidget extends StatefulWidget {
  const AppMainWidget({super.key});

  @override
  State<AppMainWidget> createState() => _AppMainWidgetState();
}

class _AppMainWidgetState extends State<AppMainWidget> {

  int currentPageIndex = 0;

  void moveTo() {  
     setState(() {
        currentPageIndex = 5;
     });
  }

  Widget HomePageWidgets() {
      return SingleChildScrollView(
         child: Column(
            children: <Widget>[
               //  AppShillSection(),
               TimerSection(),
               UsageSection(),
               ChartsSection(indexCallback: moveTo),
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

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('first_launch') ?? true;
    if (isFirst) {
       await prefs.setBool('first_launch', false);
    }
    return isFirst;
  }

  @override
  void initState() {
    super.initState();
    _checkFirstLaunchAndDisplayQuote();
  }
   
 Future<void> _checkFirstLaunchAndDisplayQuote() async {
    final _isFirst = await isFirstLaunch();
    if (_isFirst) {
       Map<String, dynamic>quote = QuotesData().getRandomQuote(); 
        _showQuoteDialog(quote);
      }
 }

  void _showQuoteDialog(Map<String, dynamic> quote) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
         child: AlertDialog(
         title: Text('Quote', style: TextStyle(fontSize: 48, fontFamily: 'Tangerine', fontWeight: FontWeight.bold)),
         backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                     topLeft: Radius.zero,
                     bottomLeft: Radius.circular(40),
                     topRight: Radius.circular(40),
                     bottomRight: Radius.circular(40),
         )),
         content: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         
         children: <Widget>[
            Text(
              "\"${quote['quote']}\"",
              style: TextStyle(
                fontSize: 32.0,
                fontFamily: 'Tangerine',
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "- ${quote['author']}",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Tangerine',
                  // fontWeight: FontWeight.bold,
                  // color: Theme.of(context).colorScheme.outline,// .withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
                     decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.primaryContainer,
                       borderRadius: BorderRadius.circular(10),
                     ),
                     padding: EdgeInsets.all(10),
                     child: Text("Ум", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: [
               // StatsShimmer(),
               HomePageWidgets(),
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
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
               onPressed: () {
                  TimerWidget.startInstantTimer(context, 0, 2, 0);
              },
              child: Text('Start', style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(height: 20),
          Text("2 minutes", style:
                        TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Theme.of(context).colorScheme.primary,
           )),
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

  Widget UsageTag(String text, BuildContext context) => Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
   );

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.primary;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: timeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: CircularProgressIndicator());
          return UsageShimmer();
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
                     color: Theme.of(context).colorScheme.surfaceContainer,
                     borderRadius: BorderRadius.circular(12),
                     boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), // Shadow color
                                  spreadRadius: 5, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                   ),
                   child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UsageTag('${data["tag"]}', context),
                          SizedBox(height: 10),
                          Text(
                            '${data['hours']} Hrs',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w100,
                              color: textColor,
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
                                color: textColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${data['seconds']} Secs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: textColor,
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
  final void Function() indexCallback;
  ChartsSection({required this.indexCallback});
  @override
  Widget build(BuildContext context) {
    return Stack(
    children:[ 
     Center(
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
            DummyChart(),
          ],
        ),
      ),
     ),
       Positioned(
            top: 8, 
            right: 8,
            child: IconButton(
              icon: Icon(Icons.arrow_circle_right_rounded, color: Theme.of(context).colorScheme.secondary),
              onPressed: indexCallback,
            ),
          )
     ]
    );
  }
}

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.shadow.withOpacity(0.3), // Optional: Semi-transparent drawer content
            child: ListView(
               padding: EdgeInsets.zero,
               children: [
                 DrawerHeader(
                   decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surfaceDim.withOpacity(0.3), // Optional: Semi-transparent drawer content
                   ),
                   child: Center(child: Text('...', style: TextStyle(
                             fontSize: 32,
                             color: Theme.of(context).colorScheme.surfaceBright,
                            ))),
                 ),
                 ListTile(
                   leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.outline),
                   title: Text('Settings', 
                                    style: TextStyle(
                                       color: Theme.of(context).colorScheme.surfaceBright
                                 ),
                              ),
                   onTap: () {
                     // Update the state of the app.
                     // ...
                   },
                 ),
                 Divider(),
                 ListTile(
                   leading: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.outline),
                    title: Text('About', 
                                    style: TextStyle(
                                       color: Theme.of(context).colorScheme.surfaceBright
                                 ),
                              ),
                   onTap: () {

                     Navigator.of(context).push(
                             MaterialPageRoute(
                               builder: (BuildContext context) => AboutWidget(
                                     cardTitle: 'Um v 0.1.0',
                                     cardDescription: 'This is a brief description of the featured item. It can span multiple lines.',
                                     cardImage: 'assets/placeholder_image.png', // Replace with your image path
                                     listItems: [ 
                                        ListItemData(
                                          leadingIcon: MdiIcons.github,
                                          title: 'Source code',
                                          description: 'https://github.com/eightbeet/project_ii',
                                        ),
                                        ListItemData(
                                          leadingIcon: MdiIcons.license,
                                          title: 'License',
                                          description: 'GNU GPLv3',
                                        ),
                                        ListItemData(
                                          leadingIcon: MdiIcons.library,
                                          title: 'Third-party libraries',
                                          description: 'Click here to see libraries the app depends on',
                                          action: () {
                                                    Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                              builder: (BuildContext context) => ThirdPartyWidget()
                                                            ));
                                                  } 
                                        ),
                                        // Add more ListItems here
                                      ],
                                    )
                               )
                             );

                     // Update the state of the app.
                     // ...
                   },
                 ),
              ],
          ),
        )
     );
  }
}

class AboutWidget extends StatelessWidget {
  final String cardTitle;
  final String cardDescription;
  final String cardImage;
  final List<ListItemData> listItems;

  const AboutWidget({
    Key? key,
    required this.cardTitle,
    required this.cardDescription,
    required this.cardImage,
    required this.listItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
         backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
         title: const Text("About") 
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         Card(
           margin: const EdgeInsets.all(8.0),
           color: Theme.of(context).scaffoldBackgroundColor,
           elevation: 0,
           shape: RoundedRectangleBorder(
             side: BorderSide(color: Colors.transparent, width: 0),
             borderRadius: BorderRadius.circular(0),
           ),
           child: Padding(
             padding: const EdgeInsets.all(16.0),
             child: Column( // Outer Column
               crossAxisAlignment: CrossAxisAlignment.start, // Align column content to the start
               children: [
                 Row( // Row for Title and Image
                   children: [
                     SizedBox(
                       width: 200.0, // Adjust width as needed
                       height: 200.0, // Adjust height as needed
                       child: Image.asset(
                         cardImage,
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) {
                           return const Center(child: Icon(Icons.image_not_supported));
                         },
                       ),
                     ),
                     const SizedBox(width: 16.0),
                     Expanded(
                       child: Text(
                         cardTitle,
                         style: const TextStyle(
                           fontSize: 18.0,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 8.0), // Add some spacing between the row and description
                 Text(
                   cardDescription,
                   style: const TextStyle(fontSize: 14.0),
                   textAlign: TextAlign.start, // Align description to the start
                 ),
               ],
             ),
           ),
         ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              final item = listItems[index];
              return Column(
                children: [
                Container( 
                  margin: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 2,
                    // borderRadius: BorderRadius.circular(4),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).colorScheme.surfaceDim, width: 1.0),
                        borderRadius: BorderRadius.circular(4),
                     ),
                    child: InkWell(
                      onTap: item.action,
                      
                      child: ListTile(
                        leading: Icon(item.leadingIcon, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)),
                        title: Text(item.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
                        subtitle: item.description != null ? Text(item.description!, style: TextStyle(color: Theme.of(context).colorScheme.primary)) : null,
                      ),
                    ),
                  ),
                 ),
                ],
              );
            },
          ),
        ),
      ],
     )
    );
  }
}

class ListItemData {
  final IconData leadingIcon;
  final String title;
  final String? description;
  final void Function()? action;

  ListItemData({
    this.action,
    required this.leadingIcon,
    required this.title,
    this.description,
  });
}


class ThirdPartyWidget extends StatelessWidget{
  List<Map<String, dynamic>> listItems = AboutData().getPackageData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
         backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
         title: const Text("Third Party") 
      ),
      body: SingleChildScrollView(
         child: Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              final item = listItems[index];
              final textStyleTitle = TextStyle(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7), fontWeight: FontWeight.bold);
              final textStyleContent = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
 
              return Container( 
                  child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column( // Outer Column
                     crossAxisAlignment: CrossAxisAlignment.start, // Align column content to the start
                     children: [
                         SizedBox(height: 8.0),
                         Text('Version', style: textStyleTitle),
                         Text(' ${item["version"]}', style: textStyleContent),

                         SizedBox(height: 8.0),
                         Text('Author', style: textStyleTitle),
                         Text('${item["author"]}', style: textStyleContent),

                         SizedBox(height: 8.0),
                         Text('License', style: textStyleTitle),
                         Text('${item["License"]}', style: textStyleContent),

                         SizedBox(height: 8.0),
                         Text('Homepage', style: textStyleTitle),
                         Text('${item["homepage"]}', style: textStyleContent),

                         SizedBox(height: 8.0),
                         Text('Description', style: textStyleTitle),
                         Text('${item["description"]}', style: textStyleContent),
                     ],
                      ),
                    ),
                   ),
                 );
               },
            ),
         ), 
        ),
     );
  }
}


class DummyChart extends StatefulWidget {
  DummyChart({super.key});

  @override
  State<DummyChart> createState() => _DummyChartState();
}

class _DummyChartState extends State<DummyChart> {
  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = true;

  Color gridColor = Colors.transparent;
  Color titleColor = Colors.transparent; // Colors.purple.withValues(alpha: 0.8);
  Color superColor = Colors.transparent; // Colors.red;
  Color coolColor = Colors.transparent; // Colors.cyan;
  Color appColor = Colors.transparent;
  Color altpColor = Colors.transparent;
  Color highColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {

   gridColor = Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8);
   titleColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.8);
   superColor = Theme.of(context).colorScheme.secondary;
   coolColor = Theme.of(context).colorScheme.primaryContainer;
   altpColor =  Theme.of(context).colorScheme.onPrimary;
   appColor = Theme.of(context).colorScheme.primary;
   highColor = Theme.of(context).colorScheme.error.withValues(alpha: 0.3);


    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rawDataSets()
                .asMap()
                .map((index, value) {
                  final isSelected = index == selectedDataSetIndex;
                  return MapEntry(
                    index,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDataSetIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 26,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryFixed
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(46),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInToLinear,
                              padding: EdgeInsets.all(isSelected ? 8 : 6),
                              decoration: BoxDecoration(
                                color: value.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInToLinear,
                              style: TextStyle(
                                color:
                                    isSelected ? value.color : gridColor,
                              ),
                              child: Text(value.title),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              RadarChartData(
                radarTouchData: RadarTouchData(
                  touchCallback: (FlTouchEvent event, response) {
                    if (!event.isInterestedForInteractions) {
                      setState(() {
                        selectedDataSetIndex = -1;
                      });
                      return;
                    }
                    setState(() {
                      selectedDataSetIndex =
                          response?.touchedSpot?.touchedDataSetIndex ?? -1;
                    });
                  },
                ),
                dataSets: showingDataSets(),
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.transparent),
                titlePositionPercentageOffset: 0.2,
                titleTextStyle:
                    TextStyle(color: titleColor, fontSize: 24),
                getTitle: (index, angle) {
                  final usedAngle =
                      relativeAngleMode ? angle + angleValue : angleValue;
                  switch (index) {
                    case 0:
                      return RadarChartTitle(
                        text: 'ᛃ', // present 
                        angle: usedAngle,
                      );
                    case 2:
                      return RadarChartTitle(
                        text: 'ᚨ', // past
                        angle: usedAngle,
                      );
                    case 1:
                      return RadarChartTitle(text: 'ᚱ', angle: usedAngle); // future
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                tickCount: 1,
                ticksTextStyle:
                    const TextStyle(color: Colors.transparent, fontSize: 10),
                tickBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: gridColor, width: 2),
              ),
              duration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withValues(alpha: 0.2)
            : rawDataSet.color.withValues(alpha: 0.05),
        borderColor: isSelected
            ? rawDataSet.color
            : rawDataSet.color.withValues(alpha: 0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'time',
        color: superColor,
        values: [
          300,
          50,
          250,
        ],
      ),
      RawDataSet(
        title: 'khronos',
        color: coolColor,
        values: [
          250,
          100,
          200,
        ],
      ),
      RawDataSet(
        title: 'час',
        color: appColor,
        values: [
          200,
          150,
          50,
        ],
      ),
      RawDataSet(
        title: 'tid',
        color: altpColor,
        values: [
          200,
          150,
          50,
        ],
      ),
      RawDataSet(
        title: 'zeit',
        color: highColor,
        values: [
          200,
          150,
          50,
        ],
      ),
    ];
  }
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}
