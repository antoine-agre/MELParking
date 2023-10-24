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
    Icon favoriteIcon = const Icon(Icons.favorite);
    Icon notFavoriteIcon = const Icon(Icons.favorite_border);

    return Card(
      child: ListTile(
        title: Text(parking.name.replaceFirst("Parking", "").trim() +
            " (${parking.id})"),
        leading: const Icon(Icons.local_parking),
        trailing: InkWell(
          child: parking.favorite ? favoriteIcon : notFavoriteIcon,
          onTap: () {
            setState(() {
              // parking.favorite = !parking.favorite;
              parking.toggleFavorite();
            });
          },
        ),
      ),
    );
  }
}
