import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    // Add more colors as needed
  ];

  static Color getRandomColor() {
    Random random = Random();
    return colorList[random.nextInt(colorList.length)];
  }
}
