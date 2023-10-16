import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking/models/Parking.dart';

class ParkingListModel extends ChangeNotifier {
  final List<Parking> _parkingList = [];
  String _lastUpdated = "";

  UnmodifiableListView<Parking> get parkingList =>
      UnmodifiableListView(_parkingList);

  String get lastUpdated => _lastUpdated;

  void updateData() async {
    final response = await http.get(Uri.parse(
        'https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=20'));

    if (response.statusCode == 200) {
      _parkingList.clear();
      _parkingList.addAll(parseJSON(response));
    } else {
      throw Exception("Failed to load parking data.");
    }

    _lastUpdated = response.headers['date'] ?? "Erreur de date";
    // response.headers.forEach((key, value) => print("[$key] $value"));

    notifyListeners();
  }
}

//Helper

List<Parking> parseJSON(http.Response response) {
  List<Parking> output = [];
  List<dynamic> parkingList = jsonDecode(response.body)['results'];
  for (var parking in parkingList) {
    output.add(Parking.fromJson(parking));
  }
  return output;
}
