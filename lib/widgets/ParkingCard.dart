import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';

class ParkingCard extends StatefulWidget {
  final Parking parking;

  const ParkingCard({Key? key, required this.parking}) : super(key: key);

  @override
  State<ParkingCard> createState() => _ParkingCardState();
}

class _ParkingCardState extends State<ParkingCard> {
  @override
  Widget build(BuildContext context) {
    Parking parking = widget.parking;
    Icon favoriteIcon = const Icon(
      Icons.favorite,
      size: 50,
      color: Colors.red,
    );
    Icon notFavoriteIcon = const Icon(
      Icons.favorite_border,
      size: 50,
      color: Colors.red,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.black,
          width: 4,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side (text)
            Expanded(
              child: Column(
                children: [
                  // Parking name
                  Container(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        // parking.name,
                        parking.colorCode.toString(),
                        textScaleFactor: 2,
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontFamily: "Caracteres",
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  // Parking Address
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      // parking.address,
                      parking.distance.toString(),
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        fontFamily: "Caracteres",
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  // Numbers line
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Display container
                        Container(
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              parking.display == "LIBRE"
                                  ? parking.emptySpaces.toString()
                                  : parking.display,
                              textScaleFactor: 5,
                              style: TextStyle(
                                fontFamily: "Dot-Matrix",
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 20,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.grey,
                        ),
                        // Capacity text
                        Column(
                          children: [
                            const Text(
                              "Capacité",
                              textScaleFactor: 0.95,
                              style: TextStyle(
                                fontFamily: "Caracteres",
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                parking.capacity.toString(),
                                textScaleFactor: 1.5,
                                style: TextStyle(fontFamily: "Caracteres"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Right side (icons)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: parking.colorCode.color,
                  ),
                  child: Icon(Icons.local_parking_rounded,
                      color: Colors.white, size: 50),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      parking.toggleFavorite();
                    });
                  },
                  child: parking.favorite ? favoriteIcon : notFavoriteIcon,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                  ),
                ),
                // InkWell(
                //   child: parking.favorite ? favoriteIcon : notFavoriteIcon,
                //   onTap: () {
                //     setState(() {
                //       // parking.favorite = !parking.favorite;
                //       parking.toggleFavorite();
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );

    // return Card(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 10),
    //           child:
    //         ),
    //         Column(
    //           children: [
    //             Text(
    //               parking.name,
    //               textScaleFactor: 1.5,
    //               // style: TextStyle(
    //               //   fontSize: 24,
    //               // ),
    //             ),
    //             Text(parking.address),
    //             // Text(parking.ville),
    //           ],
    //         ),
    //         SizedBox(
    //           width: 75,
    //           child: Center(child: Text(parking.display)),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    // return Card(
    //   child: ListTile(
    //     title: Text(parking.name.replaceFirst("Parking", "").trim() +
    //         " (${parking.emptySpaces})"),
    //     leading: const Icon(Icons.local_parking),
    //     trailing:
    //   ),
    // );
  }
}
