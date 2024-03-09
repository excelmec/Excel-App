import 'dart:convert';
import 'package:excelapp/Models/latest_news.dart';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:excelapp/Services/Database/hive_operations.dart';
import 'package:http/http.dart' as http;

fetchNewsFromStorage() async {
  print("-    News: Storage Fetch    -");
  var newsData = await HiveDB.retrieveData(valueName: "news");
  if (newsData == null) return;
  return newsData.map<News>((news) => News.fromJson(news)).toList();
}

fetchAndStoreNewsFromNet(int page, int limit) async {
  print("-    News: Network Fetch    -");
  try {
    var response = await http.get(
        Uri.parse("${APIConfig.newsbaseUrl}/?page=${page}&limit=${limit}"));
    List responseData = json.decode(response.body); //
    // List responseData = [{"id":100,"name":"Event Name","image":"url"}];
    await HiveDB.storeData(valueName: "news", value: responseData);
    print(responseData.map<News>((news) => News.fromJson(news)).toList());
    return responseData.map<News>((news) => News.fromJson(news)).toList();
  } catch (_) {
    return ("error");
  }
}
