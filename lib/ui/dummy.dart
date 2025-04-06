
import 'package:flutter/material.dart';

class DummyWidget extends StatefulWidget {
   @override
   State<DummyWidget> createState() => _DummyWidgetState();
}

class _DummyWidgetState extends State<DummyWidget> {

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Started'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
         //padding: EdgeInsets.all(20),
         margin: EdgeInsets.all(20),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surfaceContainer,
           borderRadius: BorderRadius.circular(12),
         ),
          child: Text("Hellope!"),
          ),
      );
   }
}
