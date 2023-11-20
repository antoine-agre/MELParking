import 'package:flutter/material.dart';
import 'package:parking/models/Parking.dart';

class SortControl extends StatefulWidget {
  final Parking parking;

  const SortControl({Key? key, required this.parking}) : super(key: key);

  @override
  State<SortControl> createState() => _SortControlState();
}

class _SortControlState extends State<SortControl> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Icon(Icons.local_parking_rounded), Text("test")],
      ),
    );
  }
}
