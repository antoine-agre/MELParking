import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:parking/models/Place.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({
    super.key,
  });

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<Place> places = [];

  @override
  void initState() {
    for (int i = 0; i < 20; i++) {
      places.add(Place(latitude: 0, longitude: 0, name: i.toString()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView.builder(
        onReorder: (oldIndex, newIndex) {
          HapticFeedback.lightImpact();
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Place item = places.removeAt(oldIndex);
            places.insert(newIndex, item);
          });
        },
        itemCount: places.length,
        itemBuilder: (context, index) {
          return placeCard(places[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayNewPlaceDialog(context, places);
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayNewPlaceDialog(
      BuildContext context, List<Place> places) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Entrez un lieu à ajouter"),
          content: TextField(
            onSubmitted: (String userInput) {
              userInput = userInput.trim();
              print("INPUT : ${userInput}");
              locationFromAddress(userInput).then(
                (locationList) {
                  Location newLocation = locationList.first;
                  Place newPlace = Place(
                      latitude: newLocation.latitude,
                      longitude: newLocation.longitude,
                      name: userInput);
                  setState(() {
                    places.add(newPlace);
                  });
                  print("LOCATION ADDED : ${places}");
                },
              );
              Navigator.pop(context);
            },
            decoration:
                InputDecoration(hintText: "Entrez un lieu ou une adresse ici"),
          ),
        );
      },
    );
  }

  Future<void> _displayEditNameDialog(BuildContext context, Place place) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Entrez un nouveau nom pour \"${place.name}\""),
          content: TextField(
            onSubmitted: (String userInput) {
              userInput = userInput.trim();
              print("NEW NAME : ${userInput}");

              setState(() {
                place.name = userInput;
              });

              Navigator.pop(context);
            },
            decoration: InputDecoration(hintText: place.name),
          ),
        );
      },
    );
  }

  Dismissible placeCard(Place place, int index) {
    return Dismissible(
      key: ObjectKey(place),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 8.0),
        child: Text(
          "Supprimer",
          textScaleFactor: 1.25,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      onDismissed: (direction) {
        places.removeAt(index);
      },
      child: Card(
        child: ListTile(
          title: Text(place.name),
          leading: InkWell(
            onTap: () {
              _displayEditNameDialog(context, place);
            },
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
          trailing: Icon(Icons.drag_handle_rounded),
        ),
      ),
    );
  }
}