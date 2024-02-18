import 'package:flutter/material.dart';
import 'package:travel_client/models/travelinfo.dart';

class TripView extends StatefulWidget {
  const TripView({super.key});

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {
  Map<String, dynamic> hashes = {};
  late TravelInfo travelInfo;
  @override
  Widget build(BuildContext context) {
    hashes = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    travelInfo = hashes['travelInfo'];
    return Scaffold();
  }
}
