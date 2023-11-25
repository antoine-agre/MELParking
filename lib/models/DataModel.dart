import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:parking/models/Parking.dart';
import 'package:parking/models/Place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DataModel extends ChangeNotifier {
  final List<Parking> _parkingList = [];
  DateTime _lastUpdated = DateTime.fromMillisecondsSinceEpoch(0);
  Position? _userPosition = null;
  List<Place> _placeList = [];

  UnmodifiableListView<Parking> get parkingList =>
      UnmodifiableListView(_parkingList);

  DateTime get lastUpdated => _lastUpdated;

  Position? get userPosition => _userPosition;

  UnmodifiableListView<Place> get placeList => UnmodifiableListView(_placeList);

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

          // Color code
          if ((parking.state != "OUVERT" && parking.state != "LIBRE") ||
              parking.emptySpaces <= 0) {
            parking.colorCode = ColorCode.black;
          } else if (parking.emptySpaces < 0.05 * parking.capacity ||
              parking.emptySpaces < 20) {
            parking.colorCode = ColorCode.red;
          } else if (parking.emptySpaces < 0.20 * parking.capacity) {
            parking.colorCode = ColorCode.orange;
          } else {
            parking.colorCode = ColorCode.green;
          }
        });

        _parkingList.clear();
        _parkingList.addAll(newList);
        _parkingList.sort((a, b) => a.name.compareTo(b.name));
        _updateDistances();
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
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text("Échec de récupération des données.")));
    }

    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Geolocator.openLocationSettings();
    //   return Future.error("Location services are disabled.");
    // }

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

    _updateDistances();

    notifyListeners();
    liveLocation();
    // return await Geolocator.getCurrentPosition();
  }

  void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _userPosition = position;
      _updateDistances();
      notifyListeners();
    });
  }

  Future<void> openMap([Parking? parking]) async {
    if (userPosition != null || parking != null) {
      Uri googleURL;
      if (parking == null) {
        googleURL = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=${userPosition!.latitude}%2C${userPosition!.longitude}');
      } else {
        googleURL = Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=${parking.latitude}%2C${parking.longitude}');
      }

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

  void _updateDistances() {
    // for every parking, update distance field using euclidian distance
    // between parking position and user position
    if (userPosition != null) {
      for (Parking parking in _parkingList) {
        double deltaLat = userPosition!.latitude - parking.latitude;
        double deltaLong = userPosition!.longitude - parking.longitude;
        parking.distance = sqrt(pow(deltaLat, 2) + pow(deltaLong, 2));
      }
    }
  }

  // List<Parking> _computeDistances(List<Parking> list) {
  //   // Computes distance for a list of Parking objects, and returns it.
  //   return [];
  // }

  Future<void> loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("places")) {
      List<String> stringList = prefs.getStringList("places")!;
      List<Place> newList = [];
      stringList.forEach((element) {
        newList.add(Place.fromJson(jsonDecode(element)));
      });
      _placeList = newList;
    } else {
      _placeList = [];
    }
  }

  Future<void> savePlaces(List<Place> placeList) async {
    final prefs = await SharedPreferences.getInstance();

    _placeList = placeList;

    List<String> stringList = [];
    _placeList.forEach((Place place) {
      stringList.add(jsonEncode(place.toJson()));
    });

    prefs.setStringList("places", stringList);
  }
}
