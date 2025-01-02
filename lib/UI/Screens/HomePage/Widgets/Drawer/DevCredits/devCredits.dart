import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';

import '../../../../../Themes/colors.dart';

class DevCredits extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DevCreditsState();
}

class DevCreditsState extends State<DevCredits>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  var developers = [
    // {
    //   "name":"Tom Vempala",
    //   "email": "tomthomas.mec@gmail.com",
    //   "image": "assets/devs/tom.jpg"
    // },
    // {
    //   "name": "Ashish Mathew Philip",
    //   "email": "ashishmathewphilip.mec@gmail.com",
    //   "image": "assets/devs/ashish.jpg"
    // },
    {
      "name": "Alfred Jimmy",
      "email": "alfredjimmyaj007@gmail.com",
      "image": "assets/devs/alfred.jpg"
    },
    {
      "name": "Sreehari K N",
      "email": "knsreehari2001@gmail.com",
      "image": "assets/devs/sreehari.jpg"
    },
    // {
    //   "name": "Jaison Dennis",
    //   "email": "jaisondennis080@gmail.com",
    //   "image": "assets/devs/jaison.jpg"
    // },
    // {
    //   "name": "Denin Paul",
    //   "email": "deninpaulv@gmail.com",
    //   "image": "assets/devs/denin.jpg"
    // },
    // {
    //   "name": "Athul Reji",
    //   "email": "athulreji007@gmail.com",
    //   "image": "assets/devs/athul.jpg"
    // },
    // {
    //   "name": "Faheem",
    //   "email": "send2faheempp@gmail.com",
    //   "image": "assets/devs/faheem.jpg"
    // },
    // {
    //   "name": "Nevin Manoj",
    //   "email": "nevinmanojp@gmail.com",
    //   "image": "assets/devs/nevin.jpg"
    // },
    // {
    //   "name": "Pooja Johnson",
    //   "email": "poojajohnson2002@gmail.com",
    //   "image": "assets/devs/pooja.jpg"
    // }
  ];

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: EdgeInsets.all(13),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundBlue,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Core Developers",
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                    fontFamily: pfontFamily,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  "assets/divider_design.png",
                  width: MediaQuery.of(context).size.width / 2,
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[] +
                      List.generate(
                        developers.length,
                        (index) => Container(
                          margin: EdgeInsets.only(top: 5, left: 5),
                          // color: Colors.red,
                          child: ListTile(
                            title: Text(
                              developers[index]["name"]!,
                              style: TextStyle(
                                  fontSize: 14.5, color: secondaryColor),
                            ),
                            subtitle: Text(
                              developers[index]["email"]!,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryColor.withAlpha(95)),
                            ),
                            dense: true,
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                developers[index]["image"]!,
                              ),
                            ),
                          ),
                        ),
                      ) +
                      [SizedBox(height: 10)],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
