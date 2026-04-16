// lib/Models/Major.dart

import 'package:flutter/material.dart';

class Major {
  final int? id;
  final String code;
  final String name;
  final int colorValue;

  Major({
    this.id,
    required this.code,
    required this.name,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "color": colorValue,
    };
  }

  factory Major.fromMap(Map<String, dynamic> map) {
    return Major(
      id: map["id"],
      code: map["code"],
      name: map["name"],
      colorValue: map["color"],
    );
  }
}