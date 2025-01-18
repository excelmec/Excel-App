import 'dart:convert';
import 'package:excelapp/Models/highlights_model.dart';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:excelapp/Services/Database/hive_operations.dart';
import 'package:http/http.dart' as http;

fetchHighlightsFromStorage() async {
  print("-    Highlights: Storage Fetch    -");
  var highlightsData = await HiveDB.retrieveData(valueName: "highlights");
  if (highlightsData == null) return;
  return highlightsData
      .map<Highlights>((highlight) => Highlights.fromJson(highlight))
      .toList();
}

fetchAndStoreHighlightsFromNet() async {
  print("-    Highlights: Network Fetch    -");
  try {
    var response = await http.get(Uri.parse(APIConfig.baseUrl + "highlights"));
    //List responseData = json.decode(response.body);//
    List responseData = [{"id":100,"name":"Mwone","image":'https://images.squarespace-cdn.com/content/v1/51cdafc4e4b09eb676a64e68/1540579572916-0BE4Z85H2A2Z6KWULBNG/character_head.jpg?format=2500w'},
    {
      "id":100,"name":"Event Name","image":'https://images.squarespace-cdn.com/content/v1/51cdafc4e4b09eb676a64e68/1540579572916-0BE4Z85H2A2Z6KWULBNG/character_head.jpg?format=2500w'
    }];
    //await HiveDB.storeData(valueName: "highlights", value: responseData);
    return responseData
        .map<Highlights>((highlight) => Highlights.fromJson(highlight))
        .toList();
  } catch (_) {
    return ("error");
  }
}
