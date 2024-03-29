import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Models/event_card.dart';
import 'package:excelapp/UI/Screens/Results/ResultPage/resultpage.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResultCard extends StatelessWidget {
  final Event event;
  ResultCard(this.event);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(event: event),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          child: ListTile(
            dense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              child: CachedNetworkImage(
                imageUrl: event.icon,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    child: CircleAvatar(backgroundColor: Colors.white),
                    baseColor: const Color.fromRGBO(224, 224, 224, 1),
                    highlightColor: const Color.fromRGBO(245, 245, 245, 1),
                  );
                },
              ),
            ),
            title: Text(
              event.name,
            ),
            // subtitle: Text(" "),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}
