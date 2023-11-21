import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/models/DataModel.dart';
import 'package:parking/widgets/LocationScreen.dart';
import 'package:parking/widgets/MapScreen.dart';
import 'package:parking/widgets/ParkingList.dart';
import 'package:provider/provider.dart';

// void main() {
//   // runApp(const MainApp());
//   runApp(AppDataProvider(
//       appData: AppData(parkings: [
//         Parking(name: "Forville", state: "Ouvert", emptySpaces: 56)
//       ]),
//       child: MainApp()));
// }

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ChangeNotifierProvider(
    create: (context) => DataModel(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Position? userPosition;

  @override
  void initState() {
    DataModel model = Provider.of<DataModel>(context, listen: false);
    model.fetchData(context).then((_) => FlutterNativeSplash.remove());

    Timer.periodic(Duration(minutes: 1), (timer) {
      model.fetchData(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppDataProvider? appDataProvider = AppDataProvider.of(context)!;

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Parkings de la MEL"),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Parkings", icon: Icon(Icons.local_parking)),
                Tab(text: "Carte", icon: Icon(Icons.map_rounded)),
                Tab(text: "Lieux", icon: Icon(Icons.apartment_rounded)),
                Tab(text: "GPS", icon: Icon(Icons.satellite_alt_rounded)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ParkingList(),
              MapScreen(),
              Placeholder(
                child: Text("Lieux"),
              ),
              LocationScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
