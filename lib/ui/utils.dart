import 'package:flutter/material.dart';

List<BoxShadow> ApplyBoxShadow(double alpha) {
   return [
      BoxShadow(
         color: Colors.grey.withValues(alpha: alpha),
         spreadRadius: 2,
         blurRadius: 2,
         offset: Offset(0, 3),
      ),
   ];
}


