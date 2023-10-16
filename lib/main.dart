import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';
import 'package:parking/models/ParkingListModel.dart';
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
  // const _MainAppState({super.key});

  @override
  Widget build(BuildContext context) {
    // AppDataProvider? appDataProvider = AppDataProvider.of(context)!;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Consumer<ParkingListModel>(
            builder: (context, data, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('### Hello World! ###'),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Dernière mise à jour :"),
                  Text(data.lastUpdated),
                  SizedBox(
                    height: 20,
                  ),
                  for (var parking in data.parkingList)
                    Text(
                        "${parking.name} - ${parking.state} - ${parking.emptySpaces} places libres"),
                  Text('### Hello World! ###'),
                  TextButton(
                      onPressed: () {
                        data.updateData();
                        // setState(() {
                        //   appDataProvider.appData.updateData();
                        // });
                      },
                      child: Text("aaa"))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
