import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking/models/Parking.dart';

class ParkingListModel extends ChangeNotifier {
  final List<Parking> _parkingList = [
    Parking(emptySpaces: 0, id: "1", name: "Forville", state: "FERMÉ")
  ];
  String _lastUpdated = "";

  UnmodifiableListView<Parking> get parkingList =>
      UnmodifiableListView(_parkingList);

  String get lastUpdated => _lastUpdated;

  void updateData(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(
          'https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=20'));

      if (response.statusCode == 200) {
        List<Parking> newList = _parseJSON(response);
        _parkingList.clear();
        _parkingList.addAll(newList);
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
      parking.favorite = _isFavorite(parking.id);
      output.add(parking);
    }
    return output;
  }

  bool _isFavorite(String id) {
    //returns true if parking of given id exists and is favorited.
    if (_parkingList.any((parking) => parking.id == id)) {
      return _parkingList.firstWhere((parking) => parking.id == id).favorite;
    } else {
      return false;
    }
  }
}
