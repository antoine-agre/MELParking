import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/widgets/ParkingList.dart';
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

  void openNearbyPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: Text("Autour de ${name}")),
        body: ParkingList(
          customPosition: Position(
              longitude: longitude,
              latitude: latitude,
              timestamp: null,
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0),
          placeName: name,
        ),
      );
    }));
  }
}
