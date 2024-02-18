import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'package:travel_client/auth/auth.dart';
import 'package:travel_client/pages/authstate.dart';
import 'package:travel_client/pages/tripsearch.dart';
import 'package:travel_client/pages/tripsearchresults.dart';
import 'package:travel_client/pages/tripview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthAPI(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: Colors.red,
                ),
          ),
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.dark,
                  seedColor: Colors.black,
                ),
          ),
          routes: {
            '/': (context) => AuthState(),
            '/tripSearch': (context) => TripSearch(),
            '/tripSearchResult': (context) => TripSearchResult(),
            '/tripView':(context) => TripView()
          },
        );
      },
    );
  }
}
