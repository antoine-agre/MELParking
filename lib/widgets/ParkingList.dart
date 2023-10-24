import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';
import 'package:parking/models/ParkingListModel.dart';
import 'package:parking/widgets/ParkingCard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingList extends StatefulWidget {
  final bool onlyFavorites;

  const ParkingList({super.key, this.onlyFavorites = false});

  @override
  State<ParkingList> createState() => _ParkingListState();
}

class _ParkingListState extends State<ParkingList> {
  @override
  Widget build(BuildContext context) {
    Icon favoriteIcon = const Icon(Icons.favorite);
    Icon notFavoriteIcon = const Icon(Icons.favorite_border);

    return Consumer<ParkingListModel>(
      builder: (context, data, child) {
        List<Parking> parkingList = data.parkingList;
        if (widget.onlyFavorites) {
          parkingList = List<Parking>.from(parkingList);
          parkingList.retainWhere((parking) => parking.favorite);
          parkingList = UnmodifiableListView(parkingList);
        }
        return RefreshIndicator(
          onRefresh: () async {
            final prefs = await SharedPreferences.getInstance();
            print("########");
            if (prefs.containsKey("favorites")) {
              print(prefs.getStringList("favorites"));
            } else {
              print("No favorites.");
            }
            print("########");
            return data.updateData(context);
            // return Future<void>.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: parkingList.length,
            itemBuilder: (BuildContext context, int i) {
              return ParkingCard(
                  parking: parkingList[i], key: ValueKey(parkingList[i].id));
              // return ListTile(
              //   title: Text(
              //       parkingList[i].name.replaceFirst("Parking", "").trim()),
              //   leading: const Icon(Icons.local_parking),
              //   trailing: InkWell(
              //     child:
              //         parkingList[i].favorite ? favoriteIcon : notFavoriteIcon,
              //     onTap: () {
              //       setState(() {
              //         parkingList[i].favorite = !parkingList[i].favorite;
              //       });
              //     },
              //   ),
              // );
            },
          ),
        );
      },
    );
  }
}

//TODO : function to clean strings