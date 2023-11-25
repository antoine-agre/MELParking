import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Place {
  final double latitude;
  final double longitude;
  String name;

  Place({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
    );
  }

  void setName(String newName) {
    name = newName;
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }
}
