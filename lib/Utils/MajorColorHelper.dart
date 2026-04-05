import 'package:flutter/material.dart';
import '../Data/MajorData.dart';

Color getMajorColor(String majorName) {
  try {
    return majors
        .firstWhere((m) => m.name == majorName)
        .color;
  } catch (_) {
    return Colors.grey;
  }
}