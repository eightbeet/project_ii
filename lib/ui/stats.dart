import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


import '../data/usage.dart';

class StatsBarData {
   final double x;
   final double y;

   StatsBarData({required this.x, required this.y});
}

class PieData {
   final Color color;
   final String name;
   final double value;

   PieData({required this.color, required this.name, required this.value});
}

class StatsWidget extends StatefulWidget {
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {

  final double maxHours = 24;

  int touchedIndex  = -1;

  List<PieData> pieData = [];
  List<Color> gradientColors = [];

  Color flHorizontalColor = Colors.transparent;

  double toMinutes(double seconds) {
   return (seconds / 60.0);
  }
  
  double toHours(double seconds) {
   return (seconds / 3600.0);
  }
  

  Future<List<FlSpot>> usageDataToFlSpots() async {
     double x = 0;
     List<FlSpot> list = [];
     final usageData = await AppUsageDBHelper().getInDayUsage();

     for(var data in usageData) {
       double daily = toMinutes(data['usage_time'].toDouble());
       daily = daily > 59 ? 59 : daily.roundToDouble(); // [BUG]
       list.add(FlSpot(x+=1, daily));
     }
     return list;
  }

  Future<List<BarChartGroupData>> usageDataToBarChatGroupData() async {
     double x = 0;
     List<BarChartGroupData> list = [];
     List<dynamic> perDay = await AppUsageDBHelper().calculateTimeUsageDaysPro(6);
     var reversedPerDay = perDay.reversed.toList();
     reversedPerDay = reversedPerDay.map( (x) => x == 0 ? 0.1 : x ).toList();

     for(var data in reversedPerDay) {
       final daily = toHours(data.toDouble());
       final barData = BarChartGroupData(
           x: (x++).truncate(),
           barRods: [
             BarChartRodData(
               toY: daily,
               gradient: _barsGradient,
             )
           ],
       );
       list.add(barData);
     }
     return list;
  }

  @override
  Widget build(BuildContext context) {

  flHorizontalColor = Theme.of(context).colorScheme.outlineVariant;
  
   gradientColors = [
         Theme.of(context).colorScheme.primary,
         Theme.of(context).colorScheme.tertiary,
     ];

   pieData = [
      PieData(color: Theme.of(context).colorScheme.primary, name : 'Youtube' , value: 40),
      PieData(color: Theme.of(context).colorScheme.tertiary, name : 'VLC', value: 30),
      PieData(color: Theme.of(context).colorScheme.primaryContainer, name : 'Games', value: 21),
      PieData(color: Theme.of(context).colorScheme.outline, name : 'Play', value: 7),
      PieData(color: Theme.of(context).colorScheme.primaryFixedDim, name : 'Telegram', value: 2),
   ];

    return SingleChildScrollView( child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
           padding: EdgeInsets.all(20), 
           color: Theme.of(context).colorScheme.surfaceContainerHigh,
           child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Charts',
                  style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                  ),
                 ),
               ],
            ),
        ),
        f_hoursPerDayInWeek(),
        f_usageDuringHoursOfTheDayInMinutes(),
        f_appUsagePieCharts(),
      ],
     ),
    );
  }
 
   Widget f_hoursPerDayInWeek() {
      return FutureBuilder<List<BarChartGroupData>>(
         future: usageDataToBarChatGroupData(),
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
           } else if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return Center(child: Text('No data available'));
           }

      final  usageDataToBarChatGroupData = snapshot.data!;


      return Container(
          height: 200,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
          ),
          child: BarChart(
           BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: FlBorderData(show: false),
              barGroups: usageDataToBarChatGroupData,
              gridData: barGridData,
              alignment: BarChartAlignment.spaceAround,
              maxY: maxHours,
              ),
           ),
      );
     }
   );
}
   List<Widget> showingSectionsGuide() {
      return pieData.map((data) => 
          Container(
          child: Column( 
          children : [
             Indicator(
                 color: data.color, 
                 text: data.name,
                 isSquare: false,
               ),
            SizedBox(
                 height: 4,
           ),
         ] ,), )
       ).toList();
   }

   List<PieChartSectionData> showingSections() {
   
      List<PieChartSectionData> list = [];
   
      pieData.asMap().forEach((index, data) {
         final isTouched = index == touchedIndex;
         final fontSize = isTouched ? 25.0 : 12.0;
         final radius = isTouched ? 60.0 : 50.0;
         const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
   
         list.add(
           PieChartSectionData(
              color: data.color,
              value: data.value,
              title: '${data.value}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                shadows: shadows,
              ),
            ));
         }
       );
      return list;
   }

   Widget f_appUsagePieCharts() {
       return Container(
          height: 250,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
             color: Theme.of(context).colorScheme.surfaceContainerHigh,
             borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      // pieTouchData: pieTouchData,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 28,
              ),
               Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: showingSectionsGuide(),
                ),
            ],
          ),
        );
   }

   Widget f_usageDuringHoursOfTheDayInMinutes() {

   return FutureBuilder<List<FlSpot>>(
      future: usageDataToFlSpots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

      final  usageDataToFlSpots = snapshot.data!;

      return Container(
         height: 200,
         padding: EdgeInsets.all(20),
         margin: EdgeInsets.all(20),
         decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
             ),
         child: LineChart(
          LineChartData(
            lineTouchData: lineTouchData,
            titlesData: FlTitlesData(
               show: true,
               rightTitles: const AxisTitles(
                 sideTitles: SideTitles(showTitles: false),
               ),
               topTitles: const AxisTitles(
                 sideTitles: SideTitles(showTitles: false),
               ),
               bottomTitles: AxisTitles(
                 sideTitles: SideTitles(
                   showTitles: true,
                   reservedSize: 20,
                   interval: 1,
                   getTitlesWidget: bottomTitleWidgets,
                 ),
               ),
               leftTitles: AxisTitles(
                 sideTitles: SideTitles(
                   showTitles: true,
                   interval: 1,
                   getTitlesWidget: leftTitleWidgets,
                   reservedSize: 20,
                 ),
               ),
             ),
            borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            minX: 0,
            maxX: 23,
            minY: 0,
            maxY: 70,
            gridData: lineGridData,
            lineBarsData: [
               LineChartBarData(
                spots: usageDataToFlSpots,
                // isCurved: true,
                // [BUG]: Curve goes to the wrong direciton with curve enabled.
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                     show: false,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: gradientColors
                        .map((color) => color.withValues(alpha: 0.4))
                        .toList(),
                  ),
                ),
              ),
            ]  
           ),
         ),
       );
     },
   );
 }


  Color get gridAxisLineColor => Theme.of(context).colorScheme.outlineVariant;
  Color get barToolTipTextColor => Theme.of(context).colorScheme.primaryFixedDim;

  PieTouchData get pieTouchData => PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
             setState(() {
               if (!event.isInterestedForInteractions ||
                   pieTouchResponse == null ||
                   pieTouchResponse.touchedSection == null) {
                 touchedIndex = -1;
                 return;
               }
               touchedIndex = pieTouchResponse
                   .touchedSection!.touchedSectionIndex;
             });
           },
         );

  LineTouchData get lineTouchData => LineTouchData(
                  getTouchLineStart: (_, __) => -double.infinity,
                  getTouchLineEnd: (_, __) => double.infinity,
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final lineColor = Theme.of(context).colorScheme.tertiary;
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: lineColor,
                          strokeWidth: 1.5,
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 0,
                            );
                          },
                        ),
                      );
                    }).toList();
                  });

   FlGridData get barGridData => FlGridData(
       show: true,
       checkToShowHorizontalLine: (value) => value % 10 == 0,
       getDrawingHorizontalLine: (value) => FlLine(
         color: gridAxisLineColor,
         strokeWidth: 0.5,
       ),
       drawVerticalLine: false,
     );

   FlGridData get lineGridData => FlGridData(
     show: true,
     drawVerticalLine: true,
     horizontalInterval: 10,
     verticalInterval: 2,
     getDrawingHorizontalLine: ( value) {
       return FlLine(
         strokeWidth: 1,
         color: gridAxisLineColor,
       );
     },
     getDrawingVerticalLine: (value) {
       return FlLine(
         strokeWidth: 1,
         color: gridAxisLineColor,
       );
     },
   );

   BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: barToolTipTextColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  LinearGradient get _barsGradient => LinearGradient(
   colors: [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.primaryContainer,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
  );

   Widget rightTitles(double value, TitleMeta meta) {
      if (value == meta.max) {
         return Container();
      }
      const style = TextStyle(
        fontSize: 8,
      );
      return SideTitleWidget(
        meta: meta,
        child: Text(
          meta.formattedValue,
          style: style,
        ),
      );
  }

   Widget getTitles(double value, TitleMeta meta) {
    final date = DateTime.now();
    final today = date.day; 
   
    String text;
    switch (value.toInt()) {
      case 0:
        text = ('${(today - 6)}').padLeft(2, '0');
        break;  
      case 1:  
        text = ('${(today - 5)}').padLeft(2, '0');
        break;  
      case 2:  
        text = ('${(today - 4)}').padLeft(2, '0');
        break;  
      case 3:   
        text = ('${(today - 3)}').padLeft(2, '0');
        break;  
      case 4:   
        text = ('${(today - 2)}').padLeft(2, '0');
        break;  
      case 5:   
        text = ('${(today - 1)}').padLeft(2, '0');
        break;  
      case 6:   
        text = ('${(today)}').padLeft(2, '0');
        break;
      default:
        text = '';
        break;
    }
    final isToday = text == ('${(today)}').padLeft(2, '0');
    final style = TextStyle(
       color: Theme.of(context).colorScheme.primary,
       fontWeight: FontWeight.bold,
       fontSize: 14,
    );

    return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isToday ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5)
                     :Theme.of(context).colorScheme.surfaceContainerHigh
               
    ), 
    alignment: Alignment.center,
    padding: EdgeInsets.all(3),
    child: SideTitleWidget(
      meta: meta,
      space: 2,
      child: Text(text, style: style),
    ),
   );
  }


Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
      fontSize: 10,
    );

    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('1 H', style: style);
        break;
      case 12:
        text = Text('12 H', style: style);
        break;
      case 23:
        text = Text('23 H', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1 Min';
        break;
      case 30:
        text = '30 Min';
        break;
      case 60:
        text = '69 Min';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 14,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        )
      ],
    );
  }
}
