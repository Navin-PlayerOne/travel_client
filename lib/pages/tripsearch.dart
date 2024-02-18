import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_client/models/travelinfo.dart';
import 'package:travel_client/services/services.dart';

class TripSearch extends StatefulWidget {
  const TripSearch({super.key});

  @override
  State<TripSearch> createState() => _TripState();
}

class _TripState extends State<TripSearch> {
  Map<String, dynamic> hashes = {};
  late LatLng sourceLocation;
  late LatLng destination;
  late String fromName;
  late String toName;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    hashes = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    sourceLocation =
        LatLng(hashes['source'].latitude, hashes['source'].longitude);
    destination = LatLng(hashes['dest'].latitude, hashes['dest'].longitude);
    fromName = hashes['fromName'];
    toName = hashes['toName'];
    if (isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchTripDb();
      });
    }
    isFirst = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Trip", style: GoogleFonts.poppins(fontSize: 25)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Text(fromName),
      ),
    );
  }

  searchTripDb() async {
    print("loadong..");
    CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        barrierDismissible: false);
    List<TravelInfo?> travelInfoList =
        await searchDBforTravelInfo(fromName, toName);
    travelInfoList.forEach((element) {
      print("passenger count : ");
      print(element?.passengerCount);
      print(element?.fromName);
    });
    Navigator.pop(context);
    if (travelInfoList.isNotEmpty) {
      Navigator.pushNamed(context, '/tripSearchResult',
          arguments: {'travelInfoList': travelInfoList});
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Trip not found!",
          barrierDismissible: false);
    }
  }
}
