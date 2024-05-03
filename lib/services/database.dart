import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:travel_client/auth/auth.dart';
import 'package:travel_client/constants/constants.dart';
import 'package:travel_client/models/busstopdb.dart';
import 'package:travel_client/models/travelinfo.dart';

class DatabaseAPI {
  Client client = Client();
  late Realtime realtime;
  late RealtimeSubscription subscription;
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();
  late String userId = "";
  bool _isFetching = false;

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
    realtime = Realtime(client);
  }

  getUserId() async {
    if (userId != null) {
      await account.get().then((value) => userId = value.$id);
    }
  }

  Future fetchBusStopRawData(String busStopDbID) async {
    try {
      final document = await databases.getDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: COLLECTION_BUSSTOPS,
          documentId: busStopDbID);
      print(document.data);
      if (document.data.isNotEmpty) {
        Map<String, dynamic> tempJson, json = {};
        tempJson = document.data;
        tempJson.forEach((key, value) {
          if (key != 'BusStopList') {
            json.addEntries({key: convertJsonString(value.toString())}.entries);
          } else {
            json.addEntries(
                {key: value.map((e) => convertJsonString(e)).toList()}.entries);
          }
        });
        print("corrected json object");
        print(json);
        BusStopDB busStopDB = BusStopDB.fromAppWrite(json);
        busStopDB.id = document.$id;
        return busStopDB;
      }
    } catch (e) {
      print(e);
    }
  }

  void startSubscription(String documentId, void Function(dynamic) onUpdate) {
    print("listening started");
    subscription = realtime.subscribe([
      'databases.6513fd11bdc8ea75665c.collections.652533263e5615b4741a.documents.$documentId'
    ]);

    subscription.stream.listen((event) {
      onUpdate(event);
    });
  }

  void cancelSubscription() {
    if (subscription != null) {
      subscription.close();
    }
  }

  Future<TravelInfo> fetchTripInfo(String tripId) async {
    print('Fetching data...');
    Document doc = await databases.getDocument(
        collectionId: COLLECTION_TRAVEL_INFO,
        databaseId: APPWRITE_DATABASE_ID,
        documentId: tripId);
    return TravelInfo.fromAppwrite(doc.data);
  }
}

dynamic convertJsonString(String name) {
  try {
    List<String> str = name.replaceAll("{", "").replaceAll("}", "").split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  } catch (e) {
    return name;
  }
}
