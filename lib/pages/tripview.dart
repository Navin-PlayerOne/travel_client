import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_client/models/busstopdb.dart';
import 'package:travel_client/models/travelinfo.dart';
import 'package:travel_client/services/database.dart';

class TripView extends StatefulWidget {
  const TripView({super.key});

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {
  Map<String, dynamic> hashes = {};
  late TravelInfo travelInfo;
  late bool isLoading;
  late bool isFirst;
  late DatabaseAPI db;
  late BusStopDB busStopDB;
  late String waste;
  Set<Marker> busStopMarkers = {};
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    print("init state");
    isLoading = true;
    db = DatabaseAPI();
    isFirst = true;
  }

  @override
  void dispose() {
    print("cancelling subscription");
    cancelSubscription();
    super.dispose();
  }

  void cancelSubscription() {
    db.cancelSubscription();
  }

  @override
  Widget build(BuildContext context) {
    hashes = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    travelInfo = hashes['travelInfo'];
    print(travelInfo.tripId);
    if (isFirst) {
      getBusStopMetaData();
      db.startSubscription(travelInfo.tripId, (p0) async {
        print("call back bros");
        print(p0);
        print("please wait");
        db.fetchTripInfo(travelInfo.tripId).then((value) {
          setState(() {
            travelInfo.passengerCount = value.passengerCount;
            travelInfo.currentBusStopIndex = value.currentBusStopIndex;
            travelInfo.currentLocationCoordinates =
                value.currentLocationCoordinates;
            print(travelInfo.passengerCount);
            print(travelInfo.currentLocationCoordinates.latitude);
            print(travelInfo.currentLocationCoordinates.longitude);
          });
        });
      });
      print("fetching bustop data...");
      isFirst = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Trip", style: GoogleFonts.poppins(fontSize: 25)),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: travelInfo.currentLocationCoordinates,
                      zoom: 13.5),
                  markers: {
                    Marker(
                        markerId: const MarkerId('source'),
                        position: busStopDB.from),
                    Marker(
                        markerId: const MarkerId('destination'),
                        position: busStopDB.to),
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: travelInfo.currentLocationCoordinates,
                    ),
                    ...busStopMarkers,
                  },
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId('route'),
                        points: polylinePoints
                            .decodePolyline(busStopDB.polyLineString)
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                        color: Theme.of(context).primaryColor,
                        width: 6),
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          ...getRow(
                              "Next Stop",
                              busStopDB.busStopList
                                  .elementAt(travelInfo.currentBusStopIndex)
                                  .name,
                              shortString: true),
                          ...getRow("Passenger count",
                              travelInfo.passengerCount.toString()),
                        ],
                      )),
                ),
              ]));
  }

  void getBusStopMetaData() async {
    int i = 0;
    busStopDB = await db.fetchBusStopRawData(travelInfo.busStopBbId);
    busStopDB.busStopList.forEach((busStop) {
      print(busStop.lat);
      print(busStop.lng);
      busStopMarkers.add(
        Marker(
          markerId: MarkerId("${i++}"), // Unique marker ID
          position: LatLng(busStop.lat, busStop.lng),
          infoWindow: InfoWindow(
            title: 'Bus Stop',
            snippet: busStop.name,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    });
    setState(() {
      isLoading = false;
    });
  }

  List<Widget> getRow(String arg1, String arg2, {bool shortString = false}) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(arg1,
                style: GoogleFonts.poppins(fontSize: 24),
                maxLines: 1,
                overflow: TextOverflow.fade),
            shortString
                ? Text(
                    arg2.substring(0, arg2.length < 23 ? arg2.length : 23) +
                        (arg2.length >= 23 ? '...' : ''),
                    style: GoogleFonts.poppins(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.fade)
                : Text(arg2,
                    style: GoogleFonts.poppins(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.fade),
          ],
        ),
      ),
    ];
  }
}
