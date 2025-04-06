import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

List<StatsBarData> hoursPerDayInWeek = [
   StatsBarData(x: 0, y: 6),
   StatsBarData(x: 1, y: 4),
   StatsBarData(x: 2, y: 10),
   StatsBarData(x: 3, y: 3),
   StatsBarData(x: 4, y: 9),
   StatsBarData(x: 5, y: 4),
   StatsBarData(x: 6, y: 5)
];

List<StatsBarData> usageDuringHoursOfTheDayInMinutes = [
   StatsBarData(x: 0, y: 20),
   // StatsBarData(x: 1, y: 0),
   // StatsBarData(x: 3, y: 0),
   // StatsBarData(x: 2, y: 10),
   StatsBarData(x: 4, y: 18),
   // StatsBarData(x: 5, y: 0),
   StatsBarData(x: 6, y: 34),
   // StatsBarData(x: 7, y: 52),
   // StatsBarData(x: 8, y: 54),
   StatsBarData(x: 9, y: 44),
   // StatsBarData(x: 10, y: 54),
   // StatsBarData(x: 11, y: 48),
   StatsBarData(x: 12, y: 30),
   // StatsBarData(x: 13, y: 27),
   // StatsBarData(x: 14, y: 35),
   // StatsBarData(x: 15, y: 40),
   StatsBarData(x: 16, y: 49),
   // StatsBarData(x: 17, y: 59),
   // StatsBarData(x: 18, y: 35),
   StatsBarData(x: 19, y: 49),
   // StatsBarData(x: 21, y: 31),
   StatsBarData(x: 22, y: 20),
   StatsBarData(x: 23, y: 40)
];

List<PieData> pieData = [
   PieData(color: Color(0xFF202541), name : 'Youtube' , value: 40),
   PieData(color: Color(0xFF004B3B), name : 'VLC', value: 30),
   PieData(color: Color(0xFF9BA7CF), name : 'Games', value: 21),
   PieData(color: Color(0xFF8FC3AD), name : 'Play', value: 7),
   PieData(color: Color(0xFFA2A6B9), name : 'Telegram', value: 2),
];

class StatsWidget extends StatefulWidget {
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {

  final double maxHours = 24;
  List<Color> gradientColors = [
     Color(0xFF202541),
     Color(0xFF006B54),
  ];

  int touchedIndex  = -1;

  @override
  Widget build(BuildContext context) {
     return SingleChildScrollView( child: Column(
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
              barGroups:  hoursPerDayInWeek.map((data)=> 
                 BarChartGroupData(
                     x: data.x.toInt(),
                     barRods: [
                       BarChartRodData(
                         toY: data.y,
                         gradient: _barsGradient,
                       )
                     ],
                     showingTooltipIndicators: [0],
                )).toList(),
              gridData: barGridData,
              alignment: BarChartAlignment.spaceAround,
              maxY: maxHours,
              ),
           ),
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
                color: Color(0xFFF8F8F8),
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
                      pieTouchData: PieTouchData(
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
                      ),
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
                spots: 
                    usageDuringHoursOfTheDayInMinutes.map((data) => 
                                   FlSpot(data.x, data.y) ).toList(),
                isCurved: true,
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: true,
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
 }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Colors.transparent,
          // tooltipPadding: EdgeInsets.zero,
          // tooltipMargin: 8,
        ),
      );

   FlGridData get barGridData => FlGridData(
       show: true,
       checkToShowHorizontalLine: (value) => value % 10 == 0,
       getDrawingHorizontalLine: (value) => FlLine(
         color: Theme.of(context).colorScheme.outlineVariant,
         strokeWidth: 0.5,
       ),
       drawVerticalLine: false,
     );
     
   FlGridData get lineGridData => FlGridData(
     show: true,
     drawVerticalLine: true,
     horizontalInterval: 10,
     verticalInterval: 2,
     getDrawingHorizontalLine: (value) {
       return const FlLine(
         strokeWidth: 1,
         color: Color(0xFFD1D1D1),
       );
     },
     getDrawingVerticalLine: (value) {
       return const FlLine(
         strokeWidth: 1,
         color: Color(0xFFD1D1D1),
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
              const TextStyle(
                color: Color(0xFFA2A6B9),
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

   List<BarChartGroupData> _barGroups() {
      return hoursPerDayInWeek.map((data)=> 
       BarChartGroupData(
           x: data.x.round(),
           barRods: [
             BarChartRodData(
               toY: data.y,
               gradient: _barsGradient,
             )
           ],
           showingTooltipIndicators: [0],
      )).toList();
   }

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

    final style = TextStyle(
       color: Theme.of(context).colorScheme.onPrimaryFixed,
       fontWeight: FontWeight.bold,
       fontSize: 14,
    );

    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }


Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );


    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1 H', style: style);
        break;
      case 12:
        text = const Text('12 H', style: style);
        break;
      case 23:
        text = const Text('23 H', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF000000),
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
