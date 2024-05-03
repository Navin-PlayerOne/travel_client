import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusStopDB {
  LatLng from;
  LatLng to;
  List<BusStops> busStopList;
  LatLng currentLocationCoordinates;
  String polyLineString;
  int distance;
  int duration;
  late String fromName;
  late String toName;
  late String id;

  BusStopDB(
      {required this.from,
      required this.to,
      required this.busStopList,
      required this.currentLocationCoordinates,
      required this.distance,
      required this.duration,
      required this.polyLineString});

  factory BusStopDB.fromJson(Map<String, dynamic> json) {
    final List<dynamic> busStopListJson = json['BusStopList'];
    final List<BusStops> busStopList = busStopListJson
        .map((busStopJson) => BusStops.fromJson(busStopJson))
        .toList();

    return BusStopDB(
        from: json['From'],
        to: json['To'],
        busStopList: busStopList,
        currentLocationCoordinates: json['CurrentLocationCoordinates'],
        distance: json['distance'],
        duration: json['duration'],
        polyLineString: json['polyLineString']);
  }

  factory BusStopDB.fromAppWrite(Map<String, dynamic> json) {
    print("------ busStopDb Appwrite json");
    print(json);
    BusStopDB busStopDB = BusStopDB(
      from: LatLng(
          double.parse(json['From']['lat']), double.parse(json['From']['lng'])),
      to: LatLng(
          double.parse(json['To']['lat']), double.parse(json['To']['lng'])),
      busStopList: List<BusStops>.from(
        json['BusStopList'].map((e) => BusStops.fromAppWrite(e)),
      ),
      currentLocationCoordinates: LatLng(0, 0),
      distance: int.parse(json['distance']),
      duration: int.parse(json['duration']),
      polyLineString: json['polyLineString'],
    );
    return busStopDB;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'From': {'lat': from.latitude, 'lng': from.longitude}.toString(),
      'To': {'lat': to.latitude, 'lng': to.longitude}.toString(),
      'BusStopList':
          busStopList.map((busStop) => busStop.toJson().toString()).toList(),
      // 'CurrentLocationCoordinates': {'lat': currentLocationCoordinates.latitude,'lng': currentLocationCoordinates.longitude}.toString(),
      'polyLineString': polyLineString,
      'distance': distance,
      'duration': duration
    };
    return data;
  }
}

class BusStops {
  final double lat;
  final double lng;
  final String name;
  final int distance;
  final int duration;

  // Override equality and hashCode based on lat and lng
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusStops &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lng == other.lng &&
          name == other.name &&
          distance == other.distance &&
          duration == other.duration;

  @override
  int get hashCode =>
      lat.hashCode ^
      lng.hashCode ^
      name.hashCode ^
      distance.hashCode ^
      duration.hashCode;

  BusStops(
      {required this.lat,
      required this.lng,
      required this.name,
      required this.distance,
      required this.duration});

  factory BusStops.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];
    return BusStops(
        lat: location['lat'] as double,
        lng: location['lng'] as double,
        name: json['name'] as String,
        distance: 0,
        duration: 0);
  }

  factory BusStops.fromAppWrite(Map<String, dynamic> json) {
    print("------ busStop Appwrite json");
    print(json);
    return BusStops(
        lat: double.parse(json['lat']),
        lng: double.parse(json['lng']),
        name: json['name'],
        distance: int.parse(json['distance']),
        duration: int.parse(json['duration']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'lat': lat,
      'lng': lng,
      'name': name,
      'duration': duration,
      'distance': distance
    };
    return data;
  }
}