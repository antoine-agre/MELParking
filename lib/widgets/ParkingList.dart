import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';
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
        List<Parking> parkingList = data.parkingList;
        return RefreshIndicator(
          onRefresh: () async {
            data.updateData();
            return Future<void>.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
              itemCount: parkingList.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(
                      parkingList[i].name.replaceFirst("Parking", "").trim()),
                  leading: const Icon(Icons.local_parking),
                  trailing: Icon(Icons.favorite_border),
                );
              }),
        );
      },
    );
  }
}

//TODO : function to clean strings