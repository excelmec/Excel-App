import 'dart:async';
import 'package:excelapp/Services/API/events_api.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/event_details.dart';
import '../../../Services/API/favourites_api.dart';
import 'Widgets/eventPageBody.dart';

class EventPage extends StatefulWidget {
  final int eventId;
  final String heroname;
  EventPage(this.eventId,{this.heroname='eventIcon'});
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late int _eventId;
  late StreamController<EventDetails> estream;

  @override
  void initState() {
    super.initState();
    _eventId = widget.eventId;
    print(_eventId);
    estream = StreamController<EventDetails>();
    fetchEventDetails(_eventId);
  }

  void fetchEventDetails(int id) async {
    var result1;
    result1 = await EventsAPI.fetchEventDetailsFromStorage(id);
    if (result1 != null) estream.add(result1);
    // // Fetch from net & update
    var result2 = await EventsAPI.fetchAndStoreEventDetailsFromNet(id);
    if (result2 == "error" && result1 == null) {
 
      return;
    }
    if (result2 == "error") return;
    print("$id fetched, added to DB & updated in UI");
    estream.add(result2);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<EventDetails>(
        stream: estream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == "error") {
              return Center(
                child: Text(
                  "Failed to load event. Please retry",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return MultiProvider(
              providers: [
                
                  ChangeNotifierProvider<FavouritesStatus>(create: (c)=>FavouritesStatus.instance),
              ],
              child: EventPageBody(eventDetails: snapshot.data!,heroname: widget.heroname,)
              );
          } else {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                //Background Image
                LoadingAnimation()
              ],
            );
          }
        },
      ),
    );
  }
}
