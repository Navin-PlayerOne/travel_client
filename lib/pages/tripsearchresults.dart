import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_client/models/travelinfo.dart';

class TripSearchResult extends StatefulWidget {
  const TripSearchResult({super.key});

  @override
  State<TripSearchResult> createState() => _TripSearchResultState();
}

class _TripSearchResultState extends State<TripSearchResult> {
  Map<String, dynamic> hashes = {};
  late List<TravelInfo?> travelInfoList;
  @override
  Widget build(BuildContext context) {
    hashes = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    travelInfoList = hashes['travelInfoList'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip search results",
            style: GoogleFonts.poppins(fontSize: 25)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            itemCount: travelInfoList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => goToTrip(index),
                child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: SizedBox(
                        height: 290,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              ...getColumn(
                                  "From", travelInfoList[index]!.fromName),
                              ...getColumn("To", travelInfoList[index]!.toName),
                              ...getColumn(
                                  "Passenger Count",
                                  travelInfoList[index]!
                                      .passengerCount
                                      .toString())
                            ],
                          ),
                        ))),
              );
            }),
      ),
    );
  }

  List<Widget> getColumn(String arg1, String arg2, {bool showToolTip = false}) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Text(arg1,
                style: GoogleFonts.poppins(fontSize: 23),
                maxLines: 1,
                overflow: TextOverflow.fade),
            showToolTip
                ? const Tooltip(
                    message: 'This indicates the size of each parts',
                    triggerMode: TooltipTriggerMode
                        .tap, // ensures the label appears when tapped
                    preferBelow:
                        false, // use this if you want the label above the widget
                    child: Icon(Icons.info),
                  )
                : Container()
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Text(arg2,
            style: GoogleFonts.poppins(fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.fade),
      )
    ];
  }

  goToTrip(index) {
    Navigator.pushNamed(context, '/tripView',
        arguments: {'travelInfo': travelInfoList[index]});
  }
}
