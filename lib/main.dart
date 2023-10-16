import 'package:flutter/material.dart';
import 'package:parking/widgets/AppDataProvider.dart';

void main() {
  // runApp(const MainApp());
  runApp(AppDataProvider(
      appData: AppData(parkings: [
        Parking(name: "Forville", state: "Ouvert", emptySpaces: 56)
      ]),
      child: MainApp()));
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
    AppDataProvider? appDataProvider = AppDataProvider.of(context)!;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello World!'),
              for (var parking in appDataProvider.appData.parkings)
                Text(
                    "${parking.name} - ${parking.state} - ${parking.emptySpaces} places libres"),
              Text('Hello World!'),
              TextButton(
                  onPressed: () {
                    setState(() {
                      appDataProvider.appData.updateData();
                    });
                  },
                  child: Text("aaa"))
            ],
          ),
        ),
      ),
    );
  }
}
