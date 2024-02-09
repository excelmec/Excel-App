import 'package:excelapp/Services/API/registration_api.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:flutter/material.dart';

class RegisteredEvents extends StatefulWidget {
  RegisteredEvents();

  @override
  _RegisteredEventsState createState() => _RegisteredEventsState();
}

class _RegisteredEventsState extends State<RegisteredEvents> {
  late Future registrationList;
  @override
  void initState() {
    registrationList = RegistrationAPI.fetchRegistrations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: customappbar('Registered'),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: registrationList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == "error") {
                    return Center(child: Text("An error occured, Try again"));
                  }
                  // If no data is obtained from API
                  Object? list = ["snapshot.data"];
                  if (snapshot.hasData) {
                    return Center(
                      child: Text(
                        "No Events\n\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: 14,
                    itemBuilder: (BuildContext context, int index) {
                      return Text("Event card");
                    },
                  );
                } else {
                  return LoadingAnimation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
