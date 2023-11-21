import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ColorCode {
  green(color: Colors.green),
  orange(color: Colors.orange),
  red(color: Colors.red),
  black(color: Colors.black);

  const ColorCode({required this.color});

  final Color color;
}

class Parking {
  //From JSON
  final String id;
  final String name;
  final String ville;
  final String address;
  final String display;
  final String state;
  final int emptySpaces;
  final int capacity;
  final double latitude;
  final double longitude;

  //Custom
  bool favorite = false;
  double distance = double.infinity;
  ColorCode colorCode = ColorCode.black;

  Parking({
    required this.id,
    required this.name,
    required this.ville,
    required this.address,
    required this.display,
    required this.state,
    required this.emptySpaces,
    required this.capacity,
    required this.latitude,
    required this.longitude,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      name: json['libelle'].replaceFirst("Parking", "").trim(),
      state: json['etat'],
      emptySpaces: json['dispo'],
      latitude: json['geometry']['geometry']['coordinates'][1],
      longitude: json['geometry']['geometry']['coordinates'][0],
      ville: json['ville'],
      address: json['adresse'],
      display: json['aff'],
      capacity: json['max'],
    );
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("favorites")) {
      List<String> favoritesList = prefs.getStringList("favorites")!;
      if (favorite) {
        favoritesList.remove(id);
      } else {
        if (!favoritesList.contains(id)) {
          favoritesList.add(id);
        }
      }
      prefs.setStringList("favorites", favoritesList);
    } else {
      if (!favorite) {
        prefs.setStringList("favorites", [id]);
      }
    }

    favorite = !favorite;
  }
}
