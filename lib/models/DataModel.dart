import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:parking/models/Parking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DataModel extends ChangeNotifier {
  final List<Parking> _parkingList = [
    Parking(emptySpaces: 0, id: "1", name: "Forville", state: "FERMÉ"),
    Parking(emptySpaces: 0, id: "2", name: "Forville", state: "FERMÉ"),
    Parking(emptySpaces: 0, id: "3", name: "Forville", state: "FERMÉ"),
    Parking(emptySpaces: 0, id: "4", name: "Forville", state: "FERMÉ"),
  ];
  DateTime _lastUpdated = DateTime.fromMillisecondsSinceEpoch(0);
  Position? _userPosition = null;

  UnmodifiableListView<Parking> get parkingList =>
      UnmodifiableListView(_parkingList);

  DateTime get lastUpdated => _lastUpdated;

  Position? get userPosition => _userPosition;

  // Methods

  Future<void> fetchData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(
          'https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=-1'));

      if (response.statusCode == 200) {
        print("FETCHED !");

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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur de la requête distante.")));
        throw Exception("Failed to load parking data.");
      }

      String? responseDate = response.headers['date'];
      if (responseDate != null) {
        _lastUpdated = HttpDate.parse(responseDate);
      }
      // response.headers.forEach((key, value) => print("[$key] $value"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de récupération des données.")));
    }

    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return Future.error("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    _userPosition = await Geolocator.getCurrentPosition();
    notifyListeners();
    liveLocation();
    // return await Geolocator.getCurrentPosition();
  }

  void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _userPosition = position;
      notifyListeners();
    });
  }

  Future<void> openMap() async {
    if (userPosition != null) {
      Uri googleURL = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${userPosition!.latitude}%2C${userPosition!.longitude}');

      await canLaunchUrl(googleURL)
          ? await launchUrl(googleURL)
          : throw "Couldn't launch $googleURL";
    }
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
