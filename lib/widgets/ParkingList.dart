import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';
import 'package:parking/models/DataModel.dart';
import 'package:parking/widgets/ParkingCard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortingMode { recommended, favorites, all }

class ParkingList extends StatefulWidget {
  final bool onlyFavorites;

  const ParkingList({super.key, this.onlyFavorites = false});

  @override
  State<ParkingList> createState() => _ParkingListState();
}

class _ParkingListState extends State<ParkingList> {
  SortingMode sortingMode = SortingMode.recommended;
  List<Parking> sortedList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, data, child) {
        // List<Parking> parkingList = data.parkingList;
        sortedList = List<Parking>.from(data.parkingList);

        if (data.userPosition != null) {
          if (sortingMode == SortingMode.favorites) {
            sortedList.retainWhere((parking) => parking.favorite);
          }

          if (sortingMode != SortingMode.all) {
            // Add distance to crowded parkings
            sortedList.forEach((Parking parking) {
              if (parking.colorCode == ColorCode.black) {
                parking.distance = double.infinity;
              } else if (parking.colorCode == ColorCode.red) {
                parking.distance = parking.distance * 2;
              }
            });

            // Sort by distance
            sortedList.sort((a, b) {
              double delta = a.distance - b.distance;
              if (delta < 0) {
                return -1;
              } else if (delta > 0) {
                return 1;
              } else {
                return 0;
              }
            });
          }
        }

        // if (widget.onlyFavorites) {
        //   parkingList = List<Parking>.from(parkingList);
        //   parkingList.retainWhere((parking) => parking.favorite);
        //   parkingList = UnmodifiableListView(parkingList);
        // }
        return RefreshIndicator(
          onRefresh: () async {
            final prefs = await SharedPreferences.getInstance();
            print("########");
            if (prefs.containsKey("favorites")) {
              print(prefs.getStringList("favorites"));
            } else {
              print("No favorites.");
            }
            print(data.parkingList
                .singleWhere((p) => p.id == "VAQ0002")
                .emptySpaces);
            print("########");
            return data.fetchData(context);
            // return Future<void>.delayed(const Duration(milliseconds: 500));
          },
          child: Column(
            children: [
              Text(
                sortingMode.toString(),
                textScaleFactor: 2,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ParkingCard(
                        parking: sortedList[i],
                        key: ValueKey(sortedList[i].id));
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
              ),
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: SortingMode.recommended,
                    label: Text("Proches"),
                    icon: Icon(Icons.recommend_rounded),
                  ),
                  ButtonSegment(
                    value: SortingMode.favorites,
                    label: Text("Favoris"),
                    icon: Icon(Icons.favorite_rounded),
                  ),
                  ButtonSegment(
                    value: SortingMode.all,
                    label: Text("Tous"),
                    icon: Icon(Icons.all_inclusive_rounded),
                  ),
                ],
                selected: <SortingMode>{sortingMode},
                onSelectionChanged: (Set<SortingMode> newSelection) {
                  setState(() {
                    sortingMode = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.redAccent.shade400;
                      } else {
                        return Colors.grey.shade300;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//TODO : function to clean strings
