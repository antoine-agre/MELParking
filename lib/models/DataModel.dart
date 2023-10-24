import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking/models/Parking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataModel extends ChangeNotifier {
  final List<Parking> _parkingList = [
    Parking(emptySpaces: 0, id: "1", name: "Forville", state: "FERMÉ"),
    Parking(emptySpaces: 0, id: "2", name: "Forville", state: "FERMÉ"),
    Parking(emptySpaces: 0, id: "3", name: "Forville", state: "FERMÉ"),
    Parking(emptySpaces: 0, id: "4", name: "Forville", state: "FERMÉ"),
  ];
  String _lastUpdated = "";

  UnmodifiableListView<Parking> get parkingList =>
      UnmodifiableListView(_parkingList);

  String get lastUpdated => _lastUpdated;

  Future<void> updateData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(
          'https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=-1'));

      if (response.statusCode == 200) {
        print("DONE !");

        List<String> savedFavorites = prefs.containsKey("favorites")
            ? prefs.getStringList("favorites")!
            : [];

        List<Parking> newList = _parseJSON(response);

        newList.forEach((parking) {
          if (savedFavorites.contains(parking.id)) parking.favorite = true;
        });

        _parkingList.clear();
        _parkingList.addAll(newList);
        _parkingList.sort((a, b) => a.name.compareTo(b.name));
      } else {
        throw Exception("Failed to load parking data.");
      }

      _lastUpdated = response.headers['date'] ?? "Erreur de date";
      // response.headers.forEach((key, value) => print("[$key] $value"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de récupération des données.")));
    }

    notifyListeners();
  }

  List<Parking> _parseJSON(http.Response response) {
    List<Parking> output = [];
    List<dynamic> parkingList = jsonDecode(response.body)['results'];
    for (var parkingData in parkingList) {
      Parking parking = Parking.fromJson(parkingData);
      // parking.favorite = _isFavorite(parking.id);
      output.add(parking);
    }
    return output;
  }

  bool _isFavorite(String id) {
    //returns true if parking of given id exists and is favorited.
    if (_parkingList.any((parking) => parking.id == id)) {
      return _parkingList.singleWhere((parking) => parking.id == id).favorite;
    } else {
      return false;
    }
  }
}
