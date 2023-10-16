import 'package:flutter/material.dart';
import 'package:parking/models/ParkingListModel.dart';
import 'package:provider/provider.dart';

class ParkingList extends StatefulWidget {
  const ParkingList({super.key});

  @override
  State<ParkingList> createState() => _ParkingListState();
}

class _ParkingListState extends State<ParkingList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ParkingListModel>(
      builder: (context, data, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('### Hello World! ###'),
              const SizedBox(
                height: 20,
              ),
              const Text("Dernière mise à jour :"),
              Text(data.lastUpdated),
              const SizedBox(
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
                  child: Text("Fetch data"))
            ],
          ),
        );
      },
    );
  }
}
