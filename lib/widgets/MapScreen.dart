import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parking/models/DataModel.dart';
import 'package:parking/models/Parking.dart';
import 'package:parking/models/Place.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool placesHidden = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, data, child) {
        Position? userPosition = data.userPosition;
        // Default : Lille
        LatLng center = userPosition == null
            ? LatLng(50.636565, 3.063528)
            : LatLng(userPosition.latitude, userPosition.longitude);
        MapController mapController = MapController();
        Marker? userMarker = userPosition == null
            ? null
            : Marker(
                height: 50,
                width: 50,
                point: LatLng(userPosition.latitude, userPosition.longitude),
                child: Icon(
                  Icons.directions_car_rounded,
                  size: 50,
                ),
              );

        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(keepAlive: true, initialCenter: center),
              children: [
                TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: "io.github.antoine-agre.MELParking"),
                MarkerLayer(
                  alignment: Alignment.center,
                  rotate: true,
                  markers: [
                    // User
                    if (userMarker != null) userMarker,
                    for (Parking parking in data.parkingList)
                      Marker(
                        height: 30,
                        width: 30,
                        point: LatLng(parking.latitude, parking.longitude),
                        child: InkWell(
                          onTap: () {
                            data.openMap(parking);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: parking.colorCode.color,
                            ),
                            child: Icon(Icons.local_parking_rounded,
                                color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                    if (!placesHidden)
                      for (Place place in data.placeList)
                        Marker(
                          height: 40,
                          width: 40,
                          point: LatLng(place.latitude, place.longitude),
                          child: InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.apartment_rounded,
                              size: 40,
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.all(8.0),
                width: 55,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    mapController.moveAndRotate(center, 15, 0);
                  },
                  child: Center(child: Icon(Icons.my_location_rounded)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.all(8.0),
                width: 55,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      placesHidden = !placesHidden;
                    });
                  },
                  child: Center(child: Icon(Icons.apartment_rounded)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
