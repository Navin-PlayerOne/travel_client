import 'package:google_maps_flutter/google_maps_flutter.dart';

class TravelInfo {
  String fromName;
  String toName;
  int progress;
  LatLng currentLocationCoordinates;
  String busStopBbId;
  int passengerCount;

  TravelInfo(
      {required this.fromName,
      required this.toName,
      required this.progress,
      required this.currentLocationCoordinates,
      required this.busStopBbId,
      required this.passengerCount});

  factory TravelInfo.fromMeiliSearch(Map<String, dynamic> json) {
    String tempString = json['CurrentLocationCoordinates'];
    List<String> tempLocation =
        tempString.replaceAll(RegExp(r'[\[\]]'), '').split(', ');
    return TravelInfo(
        busStopBbId: json['busStopDB_ID'],
        currentLocationCoordinates: LatLng(double.parse((tempLocation.first)),
            double.parse((tempLocation.last))),
        fromName: json['fromName'],
        toName: json['toName'],
        passengerCount: json['passengerCount'],
        progress: json['progress']);
  }
}
