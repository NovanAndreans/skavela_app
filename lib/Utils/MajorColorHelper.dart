import 'package:flutter/material.dart';
import 'package:skavela_app/Models/MajorModel.dart';
import '../Data/MajorData.dart';

Color getMajorColor(List<Major>majors, String majorName) {
  try {
    return majors
        .firstWhere((m) => m.name == majorName)
        .color;
  } catch (_) {
    return Colors.grey;
  }
}