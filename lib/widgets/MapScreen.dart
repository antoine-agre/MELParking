import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parking/models/DataModel.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
  });

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
                  markers: [
                    Marker(
                        point: LatLng(50.6154783, 3.0314817),
                        child: FlutterLogo()),
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
                    mapController.moveAndRotate(center, 13, 0);
                  },
                  child: Center(child: Icon(Icons.my_location_rounded)),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
