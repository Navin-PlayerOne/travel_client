import 'package:appwrite/appwrite.dart';
import 'package:travel_client/auth/auth.dart';
import 'package:travel_client/constants/constants.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();
  late String userId = "";

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
    getUserId();
  }

  getUserId() async {
    if (userId != null) {
      await account.get().then((value) => userId = value.$id);
    }
  }
}
