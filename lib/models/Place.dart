import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Place {
  //From JSON
  final double latitude;
  final double longitude;
  String name;

  Place({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  void setName(String newName) {
    name = newName;
  }
}
