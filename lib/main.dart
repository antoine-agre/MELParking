import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';
import 'package:parking/models/ParkingListModel.dart';
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
  runApp(ChangeNotifierProvider(
    create: (context) => ParkingListModel(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    Provider.of<ParkingListModel>(context, listen: false).updateData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppDataProvider? appDataProvider = AppDataProvider.of(context)!;

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Parkings de la MEL"),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Parkings", icon: Icon(Icons.local_parking)),
                Tab(text: "Favoris", icon: Icon(Icons.favorite)),
                Tab(text: "Destinations", icon: Icon(Icons.place)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ParkingList(),
              ParkingList(
                onlyFavorites: true,
              ),
              Center(child: Text("Tab 3")),
            ],
          ),
        ),
      ),
    );
  }
}
