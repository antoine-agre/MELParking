import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/models/DataModel.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    super.key,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, data, child) {
        Position? pos = data.userPosition;
        return LayoutBuilder(
          builder: (context, constraint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // statusIcon(data.userPosition != null, constraint),
                Text(
                  "La localisation ${pos == null ? "n'" : ""}est ${pos == null ? "pas " : ""}configurée.",
                  style: TextStyle(
                      fontSize: 20,
                      color: pos != null ? Colors.green[800] : Colors.red[800]),
                ),
                // Text(pos == null
                //     ? "Tab 4"
                //     : "Lat : ${pos.latitude}\nLong : ${pos.longitude}"),
                InkWell(
                    onTap: () {
                      data.getCurrentLocation();
                    },
                    customBorder: CircleBorder(),
                    child: statusIcon(pos != null, constraint)),
                // ElevatedButton(
                //   onPressed: () {
                //     data.getCurrentLocation();
                //     // data.liveLocation();
                //   },
                //   child: Text("Get current location"),
                // ),
                ElevatedButton(
                  onPressed: () {
                    data.openMap();
                  },
                  child: const Text("Open in Google Maps"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Icon statusIcon(bool status, BoxConstraints constraint) {
  return Icon(
    status ? Icons.check_circle_outline_rounded : Icons.build_circle_outlined,
    size: constraint.biggest.width * 0.8,
    color: status ? Colors.green : Colors.red,
  );
}
