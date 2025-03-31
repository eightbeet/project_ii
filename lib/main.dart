import 'package:flutter/material.dart';

import 'theme.dart';
import 'home.dart';
import 'timer.dart';


void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Project II';
    return MaterialApp(
      title: appTitle,
      theme: AppTheme.light,
      home: AppMainWidget(),
      // darkTheme: AppTheme.dark,
    );
  }
}

