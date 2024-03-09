import 'package:flutter/material.dart';

import '../Models/event_card.dart';

class EventsAndCompetitionsProvider with ChangeNotifier {
  late List<Event> _dataList;
  List<Event> get dataList => _dataList;

  EventsAndCompetitionsProvider(List<Event> data) {
    _dataList = data;
  }

  setData(List<Event> data) {
    _dataList = data;
    print(_dataList);
    notifyListeners();
  }

  setSearchQuery(String value) {}

  void searchCompetitions(String value) {}

  void searchEvents(String value) {}
}
