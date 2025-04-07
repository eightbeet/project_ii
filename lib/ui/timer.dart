import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import '../data/usage.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();

static void startInstantTimer(BuildContext context, int hour, int minute, int second) {
 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TimerStartedPage(hour: hour, minute: minute, second: second),
      ),
    );
   }
}

class _TimerWidgetState extends State<TimerWidget> {
  int hour = 0;
  int minute = 0;
  int second = 0;

  final int maxHour = 23;
  final int maxMinute = 59;
  final int maxSecond = 59;

  void _startTimer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerStartedPage(hour: hour, minute: minute, second: second),
      ),
    );
  }
  
  // TimerWigetState.withValues(this.hour, this.minute, this.second);
  
  @override
  Widget build(BuildContext context) {

    return Center(
            child: Column(
            children: [
            Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Text(
                    'Timer',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
         Container(
         padding: EdgeInsets.all(20),
         margin: EdgeInsets.all(24),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surfaceContainer,
           borderRadius: BorderRadius.circular(12),
         ),
         child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWheel(
              min: 0,
              max: maxHour,
              value: hour,
              title: "Hours",
              onChanged: (newValue) {
                setState(() {
                  hour = newValue;
                });
              },
            ),
            SizedBox(width: 24),
            _buildWheel(
              min: 0,
              max: maxMinute,
              value: minute,
              title: "Minutes",
              onChanged: (newValue) {
                setState(() {
                  minute = newValue;
                });
              },
            ),
            SizedBox(width: 24),
            _buildWheel(
              min: 0,
              max: maxSecond,
              value: second,
              title: "Seconds",
              onChanged: (newValue) {
                setState(() {
                  second = newValue;
                });
              },
            ),
          ],
        ),

        SizedBox(height: 20),
        Text(
          '${_formatTime(hour)} : ${_formatTime(minute)} : ${_formatTime(second)}',
          style: TextStyle(fontSize: 32, color: Theme.of(context).colorScheme.secondaryContainer),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _startTimer, 
          child: Text('Start'),
          style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
        ),
       ],
      ),
     ),
     ]),
    );
   }

   String _formatTime(int value) {
      return value.toString().padLeft(2, '0');
   }

   Widget _buildWheel({
      required int min,
      required int max,
      required int value,
      required String title,
      required ValueChanged<int> onChanged,
    }) {
      return Column( children: [
         Text(title, style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontWeight: FontWeight.w300,
                        fontSize: 20)),
         SizedBox(height: 20),
         Container(
        height: 300,
        width: 80,
        child: ListWheelScrollView.useDelegate(
          itemExtent: 128,
          physics: FixedExtentScrollPhysics(),
          useMagnifier: true,
          onSelectedItemChanged: (index) {
            onChanged(index); 
          },
          childDelegate: ListWheelChildLoopingListDelegate(
            children: List<Widget>.generate(max + 1, (index) {
              String displayValue = index.toString().padLeft(2, '0');
              bool isSelected = value == index;
              return Container(
                alignment: Alignment.center,
                child: isSelected ?

                 Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                    ),
                  child: Text( displayValue, 
                     style: TextStyle(
                     fontSize: 48,
                     color: Theme.of(context).colorScheme.surfaceTint,
                   ),
                  ),
                 )
                :
                Container(

                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text( displayValue, 
                     style: TextStyle(
                     fontSize: 48,
                     color: Theme.of(context).colorScheme.surfaceTint,
                     fontWeight: FontWeight.w300,
                   ),
                  ),
                 ), 
              );
            }),
          ),
         ),
      ),], ) ;
    }
}


class TimerStartedPage extends StatefulWidget {
  final int hour;
  final int minute;
  final int second;

  TimerStartedPage({required this.hour, required this.minute, required this.second});

  @override
  _TimerStartedPageState createState() => _TimerStartedPageState();
}

class _TimerStartedPageState extends State<TimerStartedPage> {
  late int hour;
  late int minute;
  late int second;
  late int totalSeconds;
  late int saveSeconds;
   late Timer? _timer;
  bool isTimerRunning = false;
  bool isPaused = false; 
  
  Color _circleColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    hour = widget.hour;
    minute = widget.minute;
    second = widget.second;
    totalSeconds = (hour * 3600) + (minute * 60) + second;
    saveSeconds = totalSeconds; 
    _startCountdown();
  }

  void _startCountdown() {

    if (isTimerRunning && !isPaused) return; 

    isTimerRunning = true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (totalSeconds > 0) {
            totalSeconds--;
            second = totalSeconds % 60;
            minute = (totalSeconds ~/ 60) % 60;
            hour = (totalSeconds ~/ 3600);
            _updateCircleColor();
          } else {
           print(saveSeconds); 
           AppUsageDBModify().saveUsageData(saveSeconds);
           _timer?.cancel();
           Navigator.pop(context); 
          }
        });
    });
  }

  void _pauseTimer() {
    setState(() {
      isPaused = !isPaused; 
      isTimerRunning = false;  
    });

    if (isPaused) {
      setState((){_timer?.cancel();}); 
    } else {
      _startCountdown();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false;
      Navigator.pop(context);
    });
  }

  void _updateCircleColor() {
    double ratio = totalSeconds / ((widget.hour * 3600) + (widget.minute * 60) + widget.second);
    setState(() {
      _circleColor = Color.lerp(Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.error, 1 - ratio)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _circleColor = Theme.of(context).colorScheme.primary;
    // _circleColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Started'),
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      ),
      body: Container(
         //padding: EdgeInsets.all(20),
         margin: EdgeInsets.all(20),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surfaceContainer,
           borderRadius: BorderRadius.circular(12),
         ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: totalSeconds > 0
                          ? totalSeconds / ((widget.hour * 3600) + (widget.minute * 60) + widget.second)
                          : 0,
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation(_circleColor),
                      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                    ),
                    Center(
                     child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                        ),
                       child: Text(
                           '${_formatTime(hour)}:${_formatTime(minute)}:${_formatTime(second)}',
                           style: TextStyle(fontSize: 48, color: Theme.of(context).colorScheme.primary),
                           ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 200),
              Row( 
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [ ElevatedButton(
                    onPressed: _pauseTimer,
                    child: Text(isPaused ? 'Resume' : 'Pause'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _stopTimer,
                    child: Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
             ],
             ),
            ],
          ),
      ),
    );
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }
}
