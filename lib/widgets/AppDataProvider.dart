import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppDataProvider extends InheritedWidget {
  final AppData appData;

  const AppDataProvider(
      {Key? key, required this.appData, required Widget child})
      : super(key: key, child: child);

  static AppDataProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDataProvider>();

  @override
  bool updateShouldNotify(covariant AppDataProvider oldWidget) {
    return true;
  }
}

class AppData {
  List<Parking> parkings;

  AppData({required this.parkings});

  void updateData() async {
    final response = await http.get(Uri.parse(
        'https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=20'));

    if (response.statusCode == 200) {
      parkings = parseJSON(response);
    } else {
      throw Exception("Failed to load parking data");
    }
  }

  List<Parking> parseJSON(http.Response response) {
    List<Parking> output = [];
    List<dynamic> parkingList = jsonDecode(response.body)['results'];
    for (var parking in parkingList) {
      output.add(Parking.fromJson(parking));
    }
    return output;
  }
}

class Parking {
  final String name;
  final String state;
  final int emptySpaces;

  const Parking(
      {required this.name, required this.state, required this.emptySpaces});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      name: json['libelle'],
      state: json['etat'],
      emptySpaces: json['dispo'],
    );
  }
}
