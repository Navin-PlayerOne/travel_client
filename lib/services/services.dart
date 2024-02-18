import 'package:meilisearch/meilisearch.dart';
import 'package:travel_client/constants/constants.dart';
import 'package:travel_client/models/travelinfo.dart';

Future<List<TravelInfo?>> searchDBforTravelInfo(
    String fromName, String toName) async {
  List<TravelInfo?> travelInfoList = [];
  var client = MeiliSearchClient(MEILISEARCH_URL, MEILISEARCH_API_KEY);
  var index = client.index('travelinfo');
  var SearchResult = await index.search(
      fromName,
      SearchQuery(
          attributesToHighlight: ['fromName'],
          filter: ['progress = 0 AND toName = "$toName"']));
  print(SearchResult.hits.length);
  if (SearchResult.hits.isNotEmpty) {
    for (var i = 0; i < SearchResult.hits.length; i++) {
      travelInfoList.add(TravelInfo.fromMeiliSearch(SearchResult.hits[i]));
    }
  }
  return travelInfoList;
}
